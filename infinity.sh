apt-get update -y
sudo apt update
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 80
sudo ufw allow 443
bash <(curl -Ls https://raw.githubusercontent.com/zeronxdev/xrayr/main/setup.sh)
read -p " Địa chỉ web(VD: https://example.com): " api_host
  [ -z "${api_host}" ] && api_host=https://example.com

read -p " Khóa giao tiếp(VD: example_123): " api_key
  [ -z "${api_key}" ] && api_key=example_123  

read -p " NODE ID Cổng 80: " node_id1
  [ -z "${node_id1}" ] && node_id1=0
  
read -p " NODE ID Cổng 443: " node_id2
  [ -z "${node_id2}" ] && node_id2=0
rm -rf /etc/XrayR/ht4g.crt
rm -rf /etc/XrayR/ht4g.key
openssl req -newkey rsa:2048 -x509 -sha256 -days 365 -nodes -out /etc/XrayR/ht4g.crt -keyout /etc/XrayR/ht4g.key -subj "/C=JP/ST=Tokyo/L=Chiyoda-ku/O=Google Trust Services LLC/CN=google.com"
cd /etc/XrayR
cat >config.yml <<EOF
Log:
  Level: warning 
  AccessPath: 
  ErrorPath: 
DnsConfigPath: 
RouteConfigPath:
InboundConfigPath:
OutboundConfigPath:
ConnectionConfig:
  Handshake: 4
  ConnIdle: 30 
  UplinkOnly: 2 
  DownlinkOnly: 4 
  BufferSize: 64 
Nodes:
  -
    ApiConfig:
      ApiHost: "${api_host}"
      ApiKey: "${api_key}"
      NodeID: ${node_id1}
      Timeout: 30 
      SpeedLimit: 0 
      DeviceLimit: 0 
      RuleListPath: 
    ControllerConfig:
      DisableSniffing: true
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0 
      UpdatePeriodic: 60
      EnableDNS: false 
      DNSType: AsIs 
      EnableProxyProtocol: false
      AutoSpeedLimitConfig:
        Limit: 0 
        WarnTimes: 0
        LimitSpeed: 0
        LimitDuration: 0 
      GlobalDeviceLimitConfig:
        Enable: false 
        RedisAddr: 127.0.0.1:6379 
        RedisPassword: YOUR PASSWORD 
        RedisDB: 0 
        Timeout: 5 
        Expiry: 60 
      EnableFallback: false 
      FallBackConfigs: 
        -
          SNI: 
          Alpn: 
          Path: 
          Dest: 80 
          ProxyProtocolVer: 0
      CertConfig:
        CertMode: none 
        CertDomain: "" 
        CertFile: /etc/XrayR/ht4gvpn.crt 
        KeyFile: /etc/XrayR/ht4gvpn.key
        Provider: cloudflare
        Email: ht4gvpnvip@gmail.com
        DNSEnv: 
          ALICLOUD_ACCESS_KEY: aaa
          ALICLOUD_SECRET_KEY: bbb      
  -
    ApiConfig:
      ApiHost: "${api_host}"
      ApiKey: "${api_key}"
      NodeID: ${node_id2}
      Timeout: 30 
      SpeedLimit: 0 
      DeviceLimit: 0 
      RuleListPath: 
    ControllerConfig:
      DisableSniffing: true
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0 
      UpdatePeriodic: 60
      EnableDNS: false 
      DNSType: AsIs 
      EnableProxyProtocol: false
      AutoSpeedLimitConfig:
        Limit: 0 
        WarnTimes: 0
        LimitSpeed: 0
        LimitDuration: 0 
      GlobalDeviceLimitConfig:
        Enable: false 
        RedisAddr: 127.0.0.1:6379 
        RedisPassword: YOUR PASSWORD 
        RedisDB: 0 
        Timeout: 5 
        Expiry: 60 
      EnableFallback: false 
      FallBackConfigs: 
        -
          SNI: 
          Alpn: 
          Path: 
          Dest: 80 
          ProxyProtocolVer: 0
      CertConfig:
        CertMode: file 
        CertDomain: "" 
        CertFile: /etc/XrayR/ht4g.crt 
        KeyFile: /etc/XrayR/ht4g.key
        Provider: cloudflare
        Email: ht4gvpnvip@gmail.com
        DNSEnv: 
          ALICLOUD_ACCESS_KEY: aaa
          ALICLOUD_SECRET_KEY: bbb        
EOF
sed -i "s|ApiHost:.*|ApiHost: ${api_host}|" ./config.yml
sed -i "s|ApiKey:.*|ApiKey: ${api_key}|" ./config.yml
sed -i "s|NodeID1:.*|NodeID: ${node_id1}|" ./config.yml
sed -i "s|NodeID2:.*|NodeID: ${node_id2}|" ./config.yml
clear
cd /root && xrayr restart && echo -e "   Cài Đặt Hoàn Tất!"
#Speedtest
curl -Lso- bench.sh | bash
