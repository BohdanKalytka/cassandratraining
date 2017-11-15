resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
EOF
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "lambda_policy for eni attacment"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
                "logs:*",
                "events:*",
                "ec2:DescribeNetworkInterfaces",
                "ec2:AttachNetworkInterface",
                "ec2:DescribeInstances",
                "ec2:StartInstances",
                "ec2:RunInstances",
                "ec2:CreateTags",
                "elasticloadbalancing:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_attach_rp" {
  role       = "${aws_iam_role.iam_for_lambda.name}"
  policy_arn = "${aws_iam_policy.lambda_policy.arn}"
}
