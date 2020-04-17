load("@k8s_deploy//:defaults.bzl", "k8s_deploy")
load("@io_bazel_rules_k8s//k8s:objects.bzl", "k8s_objects")

k8s_deploy(
    name = "dep",
    kind = "deployment",

    template = ":deployment.yaml",

    images = {
        "localhost:5000/rules_k8s/nginx:latest": "@nginx//image:image"
    },
)

k8s_deploy(
    name = "svc",
    kind = "service",
    template = ":service.yaml",
)

k8s_objects(
    name = "nginx",
    objects = [
        ":dep",
        ":svc",
    ],
    visibility = ["//visibility:public"],
)
