# nztest

docker run -it --rm -v $(pwd):/nztest -w /nztest/terraform hashicorp/terraform:latest init      # refresh the file changes
docker run -it --rm -v $(pwd):/nztest -w /nztest/terraform hashicorp/terraform:latest validate
docker run -it --rm -v $(pwd):/nztest -w /nztest/terraform hashicorp/terraform:latest plan -var-file="envs/dev/terraform.tfvars"

terraform 


aws sts assume-role \
  --role-arn arn:aws:iam::143709572675:role/CrossAccountSharedRole \
  --role-session-name my-cross-acct-session
=======
"AccessKeyId": "ASIASC5OCBZBYTTP7APH",
        "SecretAccessKey": "JWhCwTyce7C/xOiPuyoOKteZeSrBo5HAT3VQPnik",
        "SessionToken": "IQoJb3JpZ2luX2VjEJP//////////wEaDGV1LWNlbnRyYWwtMSJGMEQCIGpS9ln+xD6pygu+rpT0vfvePUsy81YU9HOahZT8K+BrAiBAhAP6gZl78EpSApGZzkf4DZTkzL51EZHyv4QDHSoEACqiAghsEAAaDDE0MzcwOTU3MjY3NSIMOOL+ZVVFKucqbx+PKv8BhUlj/zS93LSmjPyHalodzhBFIM/XY/8vwkoeRZVaZHDaX5PuEX48OKsKSxpcmK4j3j7+7YxX1vgjjPwxzWPKLWJrV4uXL60Q/XaBYryImGBK3GX0mrmNFkh+yyOevJTRi1d92reyd0SD++cFTxFl6EHm2uT/nbUkP0lqbr9Dke9v1ZU5FV4muN9qs7cq9Oa2cGGzpvmwgA9xut6st6xfjquENW01T1F0Nb8bYdBTGNyPWVb1ZppDAtLDAnerqSiAD2r44zn3VoRe4t01At0MOR/ZBhkS+0rdgQ1r2k60xZGLJ5BJG+ua4zwvUNfMEM5HG/Vla5bk2/OiNc1BDw5gMKrMjsIGOp4BYmoBJR3WCPSpTfVSzuh925Emy+xrIMxlZXLPlle2p/Rp+YmF3UmcxkpfS3q/AI54wNM/DuQkbtluMTLzOOfF7HmVZGeVbSlqZ695zdfk1dpUIIpvigD4vxUPVkCl0KgtIX83t87ReGINQGw05gdk+Ho2+w0CNOE9xlCqq0B0ajcdho+JogJRduMc6/depEYp7OYZXACgRAZpZAq0SJw=",
        "Expiration": "2025-06-07T03:38:34+00:00"

export AWS_ACCESS_KEY_ID="ASIASC5OCBZBYTTP7APH"
export AWS_SECRET_ACCESS_KEY="JWhCwTyce7C/xOiPuyoOKteZeSrBo5HAT3VQPnik"
export AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEJP//////////wEaDGV1LWNlbnRyYWwtMSJGMEQCIGpS9ln+xD6pygu+rpT0vfvePUsy81YU9HOahZT8K+BrAiBAhAP6gZl78EpSApGZzkf4DZTkzL51EZHyv4QDHSoEACqiAghsEAAaDDE0MzcwOTU3MjY3NSIMOOL+ZVVFKucqbx+PKv8BhUlj/zS93LSmjPyHalodzhBFIM/XY/8vwkoeRZVaZHDaX5PuEX48OKsKSxpcmK4j3j7+7YxX1vgjjPwxzWPKLWJrV4uXL60Q/XaBYryImGBK3GX0mrmNFkh+yyOevJTRi1d92reyd0SD++cFTxFl6EHm2uT/nbUkP0lqbr9Dke9v1ZU5FV4muN9qs7cq9Oa2cGGzpvmwgA9xut6st6xfjquENW01T1F0Nb8bYdBTGNyPWVb1ZppDAtLDAnerqSiAD2r44zn3VoRe4t01At0MOR/ZBhkS+0rdgQ1r2k60xZGLJ5BJG+ua4zwvUNfMEM5HG/Vla5bk2/OiNc1BDw5gMKrMjsIGOp4BYmoBJR3WCPSpTfVSzuh925Emy+xrIMxlZXLPlle2p/Rp+YmF3UmcxkpfS3q/AI54wNM/DuQkbtluMTLzOOfF7HmVZGeVbSlqZ695zdfk1dpUIIpvigD4vxUPVkCl0KgtIX83t87ReGINQGw05gdk+Ho2+w0CNOE9xlCqq0B0ajcdho+JogJRduMc6/depEYp7OYZXACgRAZpZAq0SJw="