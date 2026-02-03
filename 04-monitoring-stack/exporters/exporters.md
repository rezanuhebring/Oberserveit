# Monitoring Exporters

## Overview
Exporters are specialized agents that collect metrics from various systems and expose them in a format that Prometheus can scrape. This document covers the exporters included in the ObserveIt monitoring platform.

## Node Exporter

### Purpose
Collects hardware and OS metrics from the Docker host system.

### Configuration
- **Image**: `prom/node-exporter:latest`
- **Port**: 9100
- **Scrape Interval**: 30 seconds

### Key Metrics
- CPU usage and utilization
- Memory usage and statistics
- Disk I/O and space usage
- Network interface statistics
- System load and uptime
- Filesystem mount points

### Usage
```yaml
- job_name: 'node'
  static_configs:
    - targets: ['node-exporter:9100']
```

## Windows Exporter

### Purpose
Collects Windows-specific metrics from Windows hosts using WMI.

### Installation
The Windows Exporter must be installed on Windows hosts (not containerized):

1. Download from: https://github.com/prometheus-community/windows_exporter/releases
2. Install as Windows service:
   ```powershell
   .\windows_exporter.exe --install
   ```
3. Start the service

### Configuration
- **Default Port**: 9182
- **Scrape Interval**: 30 seconds

### Key Metrics
- Windows service status
- CPU usage by core
- Memory usage and paging
- Disk I/O and space
- Network interface statistics
- System information
- IIS metrics (if applicable)

### Usage
```yaml
- job_name: 'windows'
  static_configs:
    - targets: ['windows-host:9182']
```

## Blackbox Exporter

### Purpose
Performs blackbox monitoring of endpoints over HTTP, HTTPS, TCP, ICMP, and DNS.

### Configuration
- **Image**: `prom/blackbox-exporter:latest`
- **Port**: 9115
- **Config File**: `blackbox.yml`

### Modules
- **http_2xx**: HTTP GET request expecting 2xx response
- **http_post_2xx**: HTTP POST request expecting 2xx response
- **tcp_connect**: TCP connection check
- **icmp**: ICMP echo request (ping)

### Usage
```yaml
- job_name: 'blackbox_http'
  metrics_path: /probe
  params:
    module: [http_2xx]
  static_configs:
    - targets: ['http://example.com']
  relabel_configs:
    - target_label: __address__
      replacement: blackbox-exporter:9115
```

## SNMP Exporter

### Purpose
Collects metrics from network devices using SNMP protocol.

### Configuration
- **Image**: `prom/snmp-exporter:latest`
- **Port**: 9116
- **Config File**: `snmp.yml`

### Supported MIBs
- **if_mib**: Interface statistics
- **system**: System information
- **host**: Host resources
- **custom**: Device-specific MIBs

### Usage
```yaml
- job_name: 'snmp'
  static_configs:
    - targets: ['192.168.1.1']
  metrics_path: /snmp
  params:
    module: [if_mib]
  relabel_configs:
    - target_label: __address__
      replacement: snmp-exporter:9116
```

## Custom Exporters

### Application Exporters
For custom applications, consider these exporters:

- **Nginx Exporter**: `nginx/nginx-prometheus-exporter`
- **Apache Exporter**: `apache_exporter`
- **MySQL Exporter**: `prom/mysqld-exporter`
- **PostgreSQL Exporter**: `wrouesnel/postgres_exporter`

### Cloud Exporters
- **AWS Exporter**: `prometheus-community/cloudwatch-exporter`
- **Azure Exporter**: `prometheus-community/azure-exporter`
- **GCP Exporter**: `prometheus-community/stackdriver-exporter`

## Exporter Best Practices

### Security
- Use read-only credentials where possible
- Limit network access to exporters
- Encrypt sensitive configuration data
- Regularly update exporter versions

### Performance
- Monitor exporter resource usage
- Adjust scrape intervals based on data freshness requirements
- Use appropriate filtering to reduce metric volume
- Implement rate limiting for high-frequency metrics

### Reliability
- Configure health checks for exporters
- Implement proper logging and monitoring
- Use service discovery for dynamic environments
- Plan for exporter failures and data gaps

### Maintenance
- Keep exporters updated with latest versions
- Monitor for deprecated metrics
- Document custom configurations
- Test exporter configurations in staging

## Troubleshooting

### Common Issues

#### Exporter Not Starting
- Check container logs: `docker logs <exporter_container>`
- Verify configuration file syntax
- Check resource limits and allocations
- Review network connectivity

#### Missing Metrics
- Verify target accessibility
- Check authentication credentials
- Review exporter configuration
- Examine Prometheus scrape logs

#### High Resource Usage
- Reduce scrape frequency
- Filter unnecessary metrics
- Optimize exporter configuration
- Consider alternative exporters

#### Connection Refused
- Check firewall rules
- Verify service ports
- Confirm network configuration
- Test connectivity manually

## Configuration Examples

### Blackbox Exporter Configuration
```yaml
modules:
  http_2xx:
    prober: http
    timeout: 5s
    http:
      valid_status_codes: [200, 301, 302]
      method: GET
  tcp_connect:
    prober: tcp
    timeout: 5s
```

### SNMP Exporter Configuration
```yaml
modules:
  if_mib:
    walk:
      - 1.3.6.1.2.1.2.2  # interfaces
      - 1.3.6.1.2.1.31.1.1.1  # ifXTable
    lookups:
      - source_indexes: [ifIndex]
        lookup: 1.3.6.1.2.1.31.1.1.1.1  # ifName
```

## Monitoring Exporters

### Exporter Health
Monitor exporter uptime and responsiveness:
```promql
up{job="node"}
up{job="blackbox"}
up{job="snmp"}
```

### Performance Metrics
Track exporter performance:
```promql
prometheus_target_scrape_duration_seconds
prometheus_target_scrape_samples_post_metric_relabeling
```

### Resource Usage
Monitor container resource usage:
```promql
container_cpu_usage_seconds_total{name=~"exporter.*"}
container_memory_usage_bytes{name=~"exporter.*"}
```