exports.handler = (event, context, callback) => {
    // Load the AWS SDK for Node.js
    var AWS = require('aws-sdk');
    
    // Create service objects
    var ec2 = new AWS.EC2({
        apiVersion: '2016-11-15'
    });
    var elb = new AWS.ELB({
        apiVersion: '2012-06-01'
    });
    var cloudwatchevents = new AWS.CloudWatchEvents({
        apiVersion: '2015-10-07'
    });

    // Create empty arrays for further usage
    var stoppedinstanceids = [];
    var terminatedinstanceids = [];
    var availeniids = [];
    
    // Some env variables, provided by terraform
    var seedtagname = process.env.CASSANDRA_SEED_TAG;
    var cassandraami = process.env.CASSANDRA_AMI;
    var cassandrakey = process.env.CASSANDRA_KEY;
    var instancetype = process.env.CASSANDRA_INST_TYPE;
    var cassandratag = process.env.CASSANDRA_TAG;
    var cweventname = process.env.CLOUD_WATCH_EVENT_NAME;

    // User  data to start the instnce in cluster
    var userdatabase64 = new Buffer("#!/bin/bash \n export NODE_IP=`hostname -I` \n export SEED_LIST=\"10.0.1.50,10.0.2.50,10.0.3.50\" \n export CASSANDRA_YML=\"/etc/cassandra/conf/cassandra.yaml\" \n export CLUSTER_NAME=\"devoops_cluster\" \n export SNITCH_TYPE=\"Ec2Snitch\" \n sed -i \"/cluster_name:/c\\cluster_name: \\\'${CLUSTER_NAME}\\\'\" ${CASSANDRA_YML} \n sed -i \"/- seeds:/c\\ \ \ \ \ \ \ \ \ \ - seeds: \"${SEED_LIST}\"\"     ${CASSANDRA_YML} \n sed -i \"/listen_address:/c\\listen_address: ${NODE_IP}\"     ${CASSANDRA_YML} \n sed -i \"/rpc_address:\/c\\rpc_address: ${NODE_IP}\" ${CASSANDRA_YML} \n sed -i \"/endpoint_snitch:/c\\endpoint_snitch: ${SNITCH_TYPE}\" ${CASSANDRA_YML} \n sed -i \"/authenticator: AllowAllAuthenticator/c\\authenticator: PasswordAuthenticator\" ${CASSANDRA_YML} \n service cassandra start \n chkconfig cassandra on").toString('base64');
    
    // Describe all instances to find stopped or terminated ones
    ec2.describeInstances({}, function(err, data) {
        if (err) {
            console.error(err.toString());
        } else {
            for (var r = 0, rlen = data.Reservations.length; r < rlen; r++) {
                var reservation = data.Reservations[r];
                for (var i = 0, ilen = reservation.Instances.length; i < ilen; ++i) {
                    var instance = reservation.Instances[i];
                    var name = '';
                    var state = instance.State.Name;
                    for (var t = 0, tlen = instance.Tags.length; t < tlen; ++t) {
                        if (instance.Tags[t].Key === 'Name') {
                            name = instance.Tags[t].Value;
                            var tag = instance.Tags[t].Value;
                            if (state.toString() == "stopped" && tag.toString() == seedtagname) {
                                var addstoppedinsid = stoppedinstanceids.push(instance.InstanceId)
                            }
                            if (state.toString() == "terminated" && tag.toString() == seedtagname) {
                                var addterminatedinsid = terminatedinstanceids.push(instance.InstanceId)
                            }
                        }
                    }
                }
            }
        }
        // Check if there are stopped seeds 
        if (stoppedinstanceids.length != "0") {

            var params = {
                InstanceIds: stoppedinstanceids
            };
        // Start stopped seed
            ec2.startInstances(params, function(err, data) {
                if (err) {
                    console.log("Could not start instance", err);
                    return;
                }
                console.log("Stared instances", params);
            });
        }
        // Some useful logging
        if (stoppedinstanceids.length == "0") {
            console.log("No stopped instances detected");
        }

        if (terminatedinstanceids.length == "0") {
            console.log("No terminated instances detected");
        }
        
        // Check if thete are available ENIs for seeds
        if (terminatedinstanceids.length != "0") {
            ec2.describeNetworkInterfaces({}, function(err, data) {
                if (err) {
                    console.error(err.toString());
                } else {
                    for (var r = 0, rlen = data.NetworkInterfaces.length; r < rlen; r++) {
                        var enis = data.NetworkInterfaces[r];
                        var name = '';
                        for (var t = 0, tlen = enis.TagSet.length; t < tlen; ++t) {
                            if (enis.TagSet[t].Key === 'Name') {
                                name = enis.TagSet[t].Value;
                            }
                            if (enis.Status === 'available' && name === seedtagname) {
                                var addavaileniid = availeniids.push(enis.NetworkInterfaceId)
                            }
                        }
                    }
                }
              
                if (availeniids.length == "0") {
                    console.log("Terminated instances detected, but there are no available ENIs");
                }
                 // Create seed instances
                for (var n = 0, nlen = availeniids.length; n < nlen; ++n) {
                     
                    // Create EC2 service object
                    var ec2 = new AWS.EC2({
                        apiVersion: '2016-11-15'
                    });

                    var params = {
                        ImageId: cassandraami, 
                        InstanceType: instancetype,
                        MinCount: 1,
                        MaxCount: 1,
                        KeyName: cassandrakey,
                        UserData: userdatabase64,


                        NetworkInterfaces: [{
                            NetworkInterfaceId: availeniids[n],
                            DeviceIndex: 0,
                        }],
                    };

                    // Create the instance with predefined ENI
                    ec2.runInstances(params, function(err, data) {
                        if (err) {
                            console.log("Could not create instance", err);
                            return;
                        }
                        var instanceId = data.Instances[0].InstanceId;
                        console.log("Created instance", instanceId);
                        // Add tags to the instance
                        params = {
                            Resources: [instanceId],
                            Tags: [{
                                Key: 'Name',
                                Value: seedtagname
                            }]
                        };
                        ec2.createTags(params, function(err) {
                            console.log("Tagging instance", err ? "failure" : "success");
                        });

                        // Attach nstance to ELB
                        
                        // Find ELB by tag
                        elb.describeLoadBalancers({}, function(err, data) {
                            if (err) {
                                console.error(err.toString());
                            } else {
                                for (var r = 0, rlen = data.LoadBalancerDescriptions.length; r < rlen; r++) {
                                    var elbs = data.LoadBalancerDescriptions[r];
                                    var elbname = elbs.LoadBalancerName;


                                    var elbparams = {
                                        LoadBalancerNames: [elbname]
                                    };

                                    elb.describeTags(elbparams, function(err, data) {
                                        if (err) console.log(err, err.stack);
                                        else
                                            for (var t = 0, tlen = data.TagDescriptions.length; t < tlen; ++t) {
                                                var elbtags = data.TagDescriptions[t];
                                                if (elbtags.Tags[t].Key === 'Name') {
                                                    var elbtagname = elbtags.Tags[t].Value;
                                                }
                                                if (elbtagname === cassandratag) {
                                                    var cassandraelbname = elbs.LoadBalancerName;
                                                }
                                            }
                                            
                                        // Add created instance to ELB
                                        var params = {
                                            Instances: [{
                                                InstanceId: instanceId
                                            }],
                                            LoadBalancerName: cassandraelbname
                                        };
                                        elb.registerInstancesWithLoadBalancer(params, function(err, data) {
                                            if (err)
                                                console.log(err, err.stack);
                                            else
                                                console.log(data);
                                            console.log("Attached instance to ELB");
                                        });
                                    });
                                }
                            }

                        });
                        
                        // Add created instance to Cloudwatch lambda trigger
                        cloudwatchevents.listRules({}, function(err, data) {
                            if (err) {
                                console.error(err.toString());
                            } else {
                                for (var r = 0, rlen = data.Rules.length; r < rlen; r++) {
                                    if (data.Rules[r].Name === cweventname) {
                                        cwdatapattern = data.Rules[r].EventPattern;
                                    }
                                }
                                cwjson = JSON.parse(cwdatapattern);
                                instancesincw = cwjson.detail["instance-id"];
                                addinst = instancesincw.push(instanceId);

                            }

                            var cwparams = {
                                Name: cweventname,
                                EventPattern: JSON.stringify(cwjson),
                            };

                            cloudwatchevents.putRule(cwparams, function(err, data) {
                                if (err) console.log(err, err.stack);
                                else console.log("Succesfully updated cloud watch rule");
                            });
                        });
                    });
                }
            });
        }
    });

    callback(null, 'Execution successfull');
};
