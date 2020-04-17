load("@k8s_deploy//:defaults.bzl", "k8s_deploy")

k8s_deploy(
  name = "ingress",
  kind = "ingress",
  template = ":ingress.yaml",
  visibility = ["//visibility:public"],
)
