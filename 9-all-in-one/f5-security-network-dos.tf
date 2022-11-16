locals {
  dos-network-vectors-list = [
    "ext-hdr-too-large",
    "hop-cnt-low",
    "host-unreachable",
    "icmpv4-flood",
    "icmpv6-flood",
    "icmp-frag",
    "ip-frag-flood",
    "ip-low-ttl",
    "ip-opt-frames",
    "ipv6-ext-hdr-frames",
    "ipv6-frag-flood",
    "non-tcp-connection",
    "opt-present-with-illegal-len",
    "tcp-opt-overruns-tcp-hdr",
    "tcp-psh-flood",
    "tcp-rst-flood",
    "tcp-syn-flood",
    "tcp-synack-flood",
    "tcp-syn-oversize",
    "tcp-bad-urg",
    "tcp-window-size",
    "tidcmp",
    "too-many-ext-hdrs",
    "udp-flood",
    "unk-tcp-opt-type"
  ]

  dos-network-vectors-settings = [
    for vector in local.dos-network-vectors-list :
    {
      type          = "${vector}"
      state         = "learn-only"
      thresholdMode = "fully-automatic"
      badActorSettings = {
        enabled = true
      }
      autoDenylistSettings = {
        enabled = true
      }
    }

  ]

}