resource "kubernetes_namespace" "app" {
  metadata {
    name = "demo"
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "demo-nginx"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = "demo-nginx"
    }
  }

  spec {
    replicas = var.app_replicas

    selector {
      match_labels = {
        app = "demo-nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "demo-nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = var.app_image

          port {
            container_port = 80
          }
        }
      }
    }
  }

  depends_on = [var.depends_on_controller]
}

resource "kubernetes_service" "app" {
  metadata {
    name      = "demo-nginx-svc"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = "demo-nginx"
    }
  }

  spec {
    selector = {
      app = "demo-nginx"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

resource "kubernetes_ingress_v1" "app" {
  metadata {
    name      = "demo-nginx-ingress"
    namespace = kubernetes_namespace.app.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"                = "alb"
      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"      = "ip"
      "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\":80}]"
      "alb.ingress.kubernetes.io/healthcheck-path" = "/"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.app.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_service.app]
}
