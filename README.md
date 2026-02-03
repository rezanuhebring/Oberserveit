# ObserveIt - Windows-Based Containerized Monitoring Platform

## Overview

ObserveIt is a comprehensive monitoring platform designed for Windows environments using Docker Desktop and WSL2. It provides proactive system health monitoring, alerting, and visualization capabilities for Windows endpoints, servers, network devices, and business-critical applications.

## Architecture

The platform consists of:
- **Prometheus**: Metrics collection and storage
- **Grafana**: Visualization and dashboards
- **Alertmanager**: Alert routing and notifications
- **Node Exporter**: Host system metrics
- **Blackbox Exporter**: Application health checks
- **SNMP Exporter**: Network device monitoring

## Quick Start

### Prerequisites
- Windows 10 Pro/Enterprise (1903+) or Windows 11
- Docker Desktop 4.0+ with WSL2 enabled
- Administrator privileges
- 4GB RAM minimum, 20GB free disk space

### Deployment

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd observeit
   ```

2. **Run compatibility validation**
   ```powershell
   .\02-compatibility-validation\scripts\validate-compatibility.ps1
   ```

3. **Start the monitoring stack**
   ```bash
   cd 04-monitoring-stack
   docker-compose up -d
   ```

4. **Access the interfaces**
   - Grafana: http://localhost:3000 (admin/admin123)
   - Prometheus: http://localhost:9090
   - Alertmanager: http://localhost:9093

## Documentation Structure

```
observeit/
├── 00-okr/                          # Objectives and Key Results
├── 01-architecture/                 # System architecture docs
├── 02-compatibility-validation/     # Pre-deployment validation
├── 03-docker-platform/              # Docker setup guides
├── 04-monitoring-stack/             # Core monitoring components
├── 05-alerting-and-escalation/      # Alert strategy and contacts
├── 06-dashboards/                   # Dashboard templates
├── 07-runbooks/                     # Operational procedures
├── 08-security-and-governance/      # Security policies
└── 09-operations/                   # Operational procedures
```

## Key Features

### Comprehensive Monitoring
- Host system metrics (CPU, memory, disk, network)
- Container performance monitoring
- Application health checks
- Network device monitoring via SNMP
- Windows-specific metrics collection

### Intelligent Alerting
- Configurable alert rules with severity levels
- Multi-channel notifications (Email, SMS, Slack, Webhooks)
- Escalation policies and contact matrices
- Alert inhibition and grouping

### Rich Visualization
- Pre-built dashboards for infrastructure monitoring
- Custom dashboard creation capabilities
- Real-time metrics visualization
- Historical trend analysis

### Enterprise-Ready
- Role-based access control
- Audit logging and compliance reporting
- High availability design
- Backup and disaster recovery procedures

## Configuration

### Environment Variables
```bash
# Grafana
GF_SECURITY_ADMIN_PASSWORD=your-secure-password
GF_USERS_ALLOW_SIGN_UP=false

# SMTP Configuration (in alertmanager.yml)
SMTP_USER=your-email@domain.com
SMTP_PASSWORD=your-app-password
```

### Customizing Targets
Edit `04-monitoring-stack/prometheus/prometheus.yml` to add:
- Windows hosts for monitoring
- Network device IPs
- Application endpoints
- Custom alert rules

## Security Considerations

- Change default passwords immediately
- Configure proper firewall rules
- Implement HTTPS/TLS for production
- Regular security updates and patches
- Access control and audit logging

## Troubleshooting

### Common Issues
1. **Port conflicts**: Check if ports 3000, 9090, 9093 are available
2. **WSL2 issues**: Ensure WSL2 is properly installed and configured
3. **Permission errors**: Run Docker Desktop as administrator
4. **Memory issues**: Increase Docker Desktop memory allocation

### Logs and Diagnostics
```bash
# View service logs
docker-compose logs [service-name]

# Check service health
docker-compose ps

# Validate configuration
docker-compose config
```

## Support and Contributing

- **Documentation**: See individual folders for detailed guides
- **Issues**: Report bugs and request features
- **Contributing**: Follow the established folder structure
- **Security**: Report security issues privately

## License

This project is licensed under the terms specified in the LICENSE file.

## Version History

- **v1.0**: Initial release with core monitoring capabilities
- Comprehensive documentation and operational runbooks
- Pre-deployment validation and compatibility checking
- Security hardening and governance framework