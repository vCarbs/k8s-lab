resource "kubernetes_config_map" "traefik_https_cfg" {
  metadata {
    name      = "traefik-https-cfg"
    namespace = "default"
  }

  data = {
    "traefik.toml" = "defaultEntryPoints = [\"http\", \"https\"]\n[entryPoints]\n  [entryPoints.http]\n  address = \":80\"\n    [entryPoints.http.redirect]\n      entryPoint = \"https\"\n  [entryPoints.https]\n  address = \":443\"\n  [entryPoints.https.tls]\n[kubernetes]\n[metrics]\n  [metrics.prometheus]\n    buckets = [0.1,0.3,1.2,5.0]\n"
  }
}
