# Monitoring Architecture

## System Overview
The ObserveIt monitoring platform is a containerized solution running on Windows using Docker Desktop with WSL2 backend. It provides comprehensive monitoring, visualization, and alerting capabilities for Windows environments, network devices, and applications.

## Architecture Components

### Core Services
- **Prometheus**: Metrics collection and storage engine
- **Grafana**: Visualization and dashboard platform
- **Alertmanager**: Alert routing and notification management
- **Node Exporter**: Host system metrics collection
- **Windows Exporter**: Windows-specific metrics collection

### Optional Components
- **Loki**: Log aggregation and querying (if logging requirements identified)
- **SNMP Exporter**: Network device monitoring via SNMP
- **Blackbox Exporter**: Application health checking

## Data Flow Architecture

```
Monitored Systems → Exporters → Prometheus → Grafana/Alertmanager
                      ↓
               Alertmanager → Notification Channels
```

### Collection Layer
- **Windows Exporter**: Runs on Windows hosts, collects OS metrics via WMI
- **Node Exporter**: Containerized, monitors Docker host and containers
- **SNMP Exporter**: Polls network devices for interface statistics, device health
- **Blackbox Exporter**: Performs HTTP/TCP checks on applications

### Storage Layer
- **Prometheus TSDB**: Time-series database with 30-day retention
- **Local Storage**: Persistent volumes for configuration and data
- **Backup Strategy**: Configuration files version controlled, metrics data ephemeral

### Presentation Layer
- **Grafana Dashboards**: Pre-built dashboards for infrastructure and application monitoring
- **Alertmanager UI**: Alert status and silence management
- **API Endpoints**: REST APIs for integration with external systems

## Deployment Architecture

### Container Orchestration
- **Docker Compose**: Single-command deployment of entire monitoring stack
- **WSL2 Backend**: Linux containers on Windows host
- **Volume Mounts**: Persistent storage for configurations and data

### Networking
- **Bridge Network**: Isolated container communication
- **Port Mapping**: External access to Grafana (3000), Prometheus (9090), Alertmanager (9093)
- **Service Discovery**: Static configuration for known endpoints

### Security Architecture
- **Container Isolation**: Non-privileged containers where possible
- **Network Segmentation**: Monitoring traffic isolated from production networks
- **Access Control**: Grafana authentication and authorization
- **Encryption**: TLS termination at reverse proxy (future enhancement)

## Scalability Considerations

### Vertical Scaling
- **Resource Allocation**: Configurable CPU/memory limits per container
- **Storage Expansion**: External storage mount points for metrics data
- **Performance Tuning**: Prometheus query optimization and caching

### Horizontal Scaling
- **Federation**: Multiple Prometheus instances for large environments
- **Load Balancing**: External load balancer for high availability
- **Remote Write**: Offload metrics to centralized storage

## High Availability Design

### Single Node HA
- **Container Restart**: Automatic restart on failure
- **Data Persistence**: Volume mounts prevent data loss
- **Health Checks**: Container health monitoring and automatic recovery

### Multi-Node Considerations
- **Prometheus Clustering**: Federation for distributed monitoring
- **Alertmanager Clustering**: Multiple instances for redundancy
- **Shared Storage**: Network-attached storage for configuration sharing

## Integration Points

### External Systems
- **Email/SMS**: Alert notifications via SMTP gateways
- **Webhooks**: Integration with incident management systems
- **APIs**: RESTful APIs for metrics querying and alert management

### Internal Components
- **Configuration Management**: Git-based configuration versioning
- **Log Aggregation**: Optional Loki integration for centralized logging
- **Metrics Export**: Prometheus federation for multi-environment monitoring