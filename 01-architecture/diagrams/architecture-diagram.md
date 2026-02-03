# System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    Windows Host (Docker Desktop + WSL2)         │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │  Grafana    │  │ Alertmanager│  │ Prometheus  │  │ Node    │ │
│  │  (Port 3000)│  │ (Port 9093) │  │ (Port 9090) │  │Exporter │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │ Windows     │  │ SNMP        │  │ Blackbox    │              │
│  │ Exporter    │  │ Exporter    │  │ Exporter    │              │
│  │ (WMI)       │  │ (SNMP)      │  │ (HTTP/TCP)  │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
└─────────────────────────────────────────────────────────────────┘
           │                        │                        │
           └────────────────────────┼────────────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
           ┌────────▼───────┐ ┌─────▼──────┐ ┌─────▼──────┐
           │ Windows Hosts  │ │ Network     │ │ Applications│
           │ & Servers      │ │ Devices     │ │ & Services  │
           └────────────────┘ └─────────────┘ └─────────────┘
```

## Component Descriptions

### Core Monitoring Stack
- **Prometheus**: Central metrics collection and storage
- **Grafana**: Visualization and dashboard platform
- **Alertmanager**: Alert routing and notification management

### Exporters
- **Node Exporter**: Host system metrics (CPU, memory, disk, network)
- **Windows Exporter**: Windows-specific metrics via WMI
- **SNMP Exporter**: Network device monitoring
- **Blackbox Exporter**: Application health and connectivity checks

### Monitored Systems
- **Windows Hosts & Servers**: OS metrics, service status, performance counters
- **Network Devices**: Interface statistics, device health, bandwidth utilization
- **Applications & Services**: HTTP health checks, response times, custom metrics

## Data Flow
1. Exporters collect metrics from monitored systems
2. Metrics are scraped by Prometheus every 15-60 seconds
3. Prometheus evaluates alert rules and sends alerts to Alertmanager
4. Alertmanager routes notifications via email, webhooks, etc.
5. Grafana queries Prometheus for dashboard visualization
6. Users access Grafana for monitoring views and Alertmanager for alert management