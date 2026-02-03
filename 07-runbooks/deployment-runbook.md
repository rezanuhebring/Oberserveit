# Deployment Runbook

## Overview
This runbook provides step-by-step instructions for deploying the ObserveIt monitoring platform on Windows using Docker Desktop.

## Prerequisites

### System Requirements
- [ ] Windows 10 Pro/Enterprise (1903+) or Windows 11
- [ ] Minimum 4GB RAM, 20GB free disk space
- [ ] Administrator privileges
- [ ] Internet connectivity

### Software Requirements
- [ ] Docker Desktop 4.0+ installed
- [ ] WSL2 enabled and configured
- [ ] PowerShell 5.1+ available
- [ ] Git for version control

### Network Requirements
- [ ] Firewall ports 3000, 9090, 9093 open
- [ ] DNS resolution working
- [ ] Internet access for container downloads

## Pre-Deployment Checklist

### Compatibility Validation
- [ ] Run compatibility validation script
- [ ] Review validation report
- [ ] Address any critical issues
- [ ] Document exceptions if any

### Environment Preparation
- [ ] Disable Windows sleep/hibernation
- [ ] Configure power settings for 24/7 operation
- [ ] Set auto-start for Docker Desktop
- [ ] Configure antivirus exclusions

### Backup and Recovery
- [ ] Backup existing monitoring configurations
- [ ] Document current monitoring setup
- [ ] Plan rollback procedures
- [ ] Test backup restoration

## Deployment Steps

### Step 1: Repository Setup
```bash
# Clone the repository
git clone https://github.com/your-org/observeit.git
cd observeit

# Verify file structure
ls -la
```

### Step 2: Environment Configuration
```powershell
# Set execution policy for scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Validate Docker installation
docker --version
docker-compose --version

# Check WSL2 status
wsl --list --verbose
```

### Step 3: Configuration Customization
```powershell
# Edit configuration files as needed
notepad 04-monitoring-stack/prometheus/prometheus.yml
notepad 04-monitoring-stack/alertmanager/alertmanager.yml
notepad 04-monitoring-stack/grafana/provisioning/datasources/datasources.yml
```

#### Key Configuration Changes
- Update SMTP settings for email notifications
- Configure monitoring targets (IP addresses, hostnames)
- Set appropriate resource limits
- Configure authentication credentials

### Step 4: Initial Deployment
```powershell
# Navigate to monitoring stack directory
cd 04-monitoring-stack

# Start the monitoring stack
docker-compose up -d

# Verify deployment
docker-compose ps
```

### Step 5: Service Validation
```powershell
# Check service health
curl http://localhost:9090/-/healthy
curl http://localhost:3000/api/health
curl http://localhost:9093/-/healthy

# View service logs
docker-compose logs prometheus
docker-compose logs grafana
docker-compose logs alertmanager
```

### Step 6: Dashboard Configuration
1. Open Grafana at http://localhost:3000
2. Login with admin/admin123 (change password)
3. Verify data sources are configured
4. Import dashboard JSON files from 06-dashboards/exports/
5. Configure dashboard permissions

### Step 7: Alert Configuration
1. Open Alertmanager at http://localhost:9093
2. Verify alert routing configuration
3. Test alert notifications (optional test alert)
4. Configure notification channels

### Step 8: Monitoring Validation
```powershell
# Check Prometheus targets
curl http://localhost:9090/api/v1/targets

# Verify metrics collection
curl http://localhost:9090/api/v1/query?query=up

# Test alert rules
curl http://localhost:9090/api/v1/rules
```

## Post-Deployment Configuration

### Security Hardening
- [ ] Change default Grafana password
- [ ] Configure user authentication
- [ ] Set up HTTPS/TLS certificates
- [ ] Implement access controls
- [ ] Configure audit logging

### Performance Tuning
- [ ] Adjust scrape intervals based on requirements
- [ ] Configure appropriate retention periods
- [ ] Set resource limits for containers
- [ ] Optimize query performance

### Integration Setup
- [ ] Configure external alert destinations
- [ ] Set up webhook integrations
- [ ] Configure SNMP monitoring for network devices
- [ ] Install Windows exporters on target hosts

### Backup Configuration
- [ ] Set up automated backups of configurations
- [ ] Configure data retention policies
- [ ] Test backup and restore procedures
- [ ] Document backup schedules

## Monitoring and Maintenance

### Health Monitoring
- [ ] Monitor Docker container health
- [ ] Track resource utilization
- [ ] Monitor alert effectiveness
- [ ] Review dashboard usage

### Regular Maintenance
- [ ] Update Docker images monthly
- [ ] Review and update alert rules quarterly
- [ ] Archive old metrics data
- [ ] Update documentation

### Troubleshooting
- [ ] Check service logs for errors
- [ ] Verify network connectivity
- [ ] Validate configuration syntax
- [ ] Test component communications

## Rollback Procedures

### Emergency Rollback
```powershell
# Stop the monitoring stack
cd 04-monitoring-stack
docker-compose down

# Restore previous configuration
# [Restore backup procedures]

# Restart with previous setup
# [Previous monitoring system startup]
```

### Partial Rollback
- Stop individual problematic services
- Revert configuration changes
- Restart services with previous configuration
- Monitor for resolution

## Validation Checklist

### Functional Validation
- [ ] All services start successfully
- [ ] Web interfaces accessible
- [ ] Metrics collection working
- [ ] Alerts firing correctly
- [ ] Dashboards displaying data

### Performance Validation
- [ ] Response times within acceptable limits
- [ ] Resource usage within configured limits
- [ ] No excessive logging or errors
- [ ] Dashboard load times acceptable

### Integration Validation
- [ ] Alert notifications working
- [ ] External system integrations functional
- [ ] Authentication and authorization working
- [ ] Backup and restore procedures tested

## Documentation Updates

### Post-Deployment Documentation
- [ ] Update network diagrams with new IPs
- [ ] Document custom configurations
- [ ] Update contact information
- [ ] Create user access guides

### Operational Documentation
- [ ] Update monitoring runbooks
- [ ] Document alert response procedures
- [ ] Update escalation contacts
- [ ] Create troubleshooting guides

## Success Criteria

### Deployment Success
- [ ] All services running and healthy
- [ ] Metrics collection from all targets
- [ ] Alert notifications functional
- [ ] Dashboards accessible and populated
- [ ] Operations team trained and confident

### Operational Readiness
- [ ] Monitoring coverage meets requirements
- [ ] Response times within SLAs
- [ ] Alert accuracy acceptable
- [ ] Documentation complete and accessible

## Support and Escalation

### During Deployment
- **Technical Issues**: Contact SRE team lead
- **Configuration Questions**: Refer to architecture documentation
- **Environment Issues**: Contact infrastructure team
- **Security Concerns**: Contact security team

### Post-Deployment Support
- **Monitoring Issues**: SRE on-call rotation
- **Application Issues**: Development teams
- **Infrastructure Issues**: Infrastructure team
- **Security Issues**: Security operations center

## Change Management

### Deployment Approval
- [ ] Change request approved
- [ ] Rollback plan documented
- [ ] Testing completed
- [ ] Stakeholders notified

### Post-Implementation Review
- [ ] Deployment success confirmed
- [ ] Lessons learned documented
- [ ] Process improvements identified
- [ ] Future enhancements planned