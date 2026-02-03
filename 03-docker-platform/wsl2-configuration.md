# WSL2 Configuration Guide

## Overview
Windows Subsystem for Linux 2 (WSL2) provides the Linux kernel and container runtime required for Docker Desktop on Windows. This guide covers WSL2 configuration specifically for the ObserveIt monitoring platform.

## WSL2 Architecture

### Components
- **WSL2 Linux Kernel**: Lightweight Linux kernel running in Hyper-V
- **Init System**: Systemd or custom init for service management
- **Container Runtime**: Containerd or runc for OCI containers
- **Filesystem**: Ext4 filesystem with metadata integration
- **Network Stack**: Virtual network interface with NAT

### Integration Points
- Windows filesystem access via `/mnt/c`
- Shared memory for interop
- Socket forwarding for localhost access
- GPU acceleration support
- USB device passthrough

## Installation and Setup

### Prerequisites
- Windows 10 version 1903+ or Windows 11
- Administrator privileges
- Virtualization enabled in BIOS
- Windows Update current

### Installation Steps
1. Enable required Windows features:
   ```powershell
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```

2. Restart computer

3. Download WSL2 kernel update:
   - Visit: https://aka.ms/wsl2kernel
   - Install the MSI package

4. Set WSL2 as default version:
   ```powershell
   wsl --set-default-version 2
   ```

5. Install Ubuntu distribution (recommended):
   ```powershell
   wsl --install -d Ubuntu
   ```

## Configuration for Monitoring

### WSL2 Settings
1. Create `.wslconfig` file in user profile:
   ```ini
   [wsl2]
   memory=4GB
   processors=2
   swap=2GB
   localhostForwarding=true
   ```

2. Configure resource limits based on system capacity:
   - Development: 2GB RAM, 1 CPU
   - Production: 8GB RAM, 4 CPUs

### Docker Integration
1. Enable WSL2 backend in Docker Desktop
2. Configure shared drives for volume mounts
3. Set up file sharing permissions
4. Configure proxy settings if applicable

## Performance Optimization

### Memory Management
- Set appropriate memory limits to prevent host starvation
- Configure swap file for memory-intensive workloads
- Monitor memory usage with `wsl --list --verbose`

### CPU Optimization
- Allocate appropriate CPU cores
- Enable CPU affinity for consistent performance
- Monitor CPU usage across WSL instances

### Storage Optimization
- Use SSD storage for WSL2 virtual disks
- Configure disk compaction: `wsl --shutdown; Optimize-VHD -Path .\ext4.vhdx -Mode Full`
- Implement log rotation for container logs

### Network Optimization
- Enable localhost forwarding for container access
- Configure DNS settings in WSL2
- Optimize network interface settings

## Security Configuration

### Access Control
- Limit WSL2 access to authorized users
- Configure sudo permissions in Linux distributions
- Implement proper file permissions

### Network Security
- Isolate WSL2 network from host network when possible
- Configure firewall rules for WSL2 interfaces
- Monitor network traffic for suspicious activity

### Data Protection
- Encrypt sensitive data at rest
- Implement backup strategies for WSL2 instances
- Secure credential management

## Monitoring WSL2 Health

### System Monitoring
- Monitor WSL2 resource usage
- Track kernel logs: `dmesg`
- Monitor systemd services: `systemctl status`

### Performance Monitoring
- Use `top` and `htop` for process monitoring
- Monitor disk I/O with `iotop`
- Track network statistics with `ip -s link`

### Log Management
- Configure syslog for centralized logging
- Implement log rotation
- Monitor for error conditions

## Troubleshooting

### Common Issues

#### WSL2 Won't Start
```powershell
# Check WSL status
wsl --list --verbose

# Restart WSL service
wsl --shutdown
wsl --start Ubuntu
```

#### Network Connectivity Issues
```bash
# Check network configuration
ip addr show
ip route show

# Restart network interface
sudo systemctl restart systemd-networkd
```

#### Performance Problems
```powershell
# Check resource usage
wsl --list --verbose

# Optimize VHD
wsl --shutdown
optimize-vhd -Path "$env:USERPROFILE\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu*\LocalState\ext4.vhdx" -Mode Full
```

#### Docker Integration Issues
- Verify Docker Desktop WSL2 backend
- Check shared drives configuration
- Restart Docker Desktop and WSL2

### Diagnostic Commands
```powershell
# WSL2 system information
wsl --system-info

# List installed distributions
wsl --list --all

# Check WSL version
wsl --version
```

```bash
# System resource usage
free -h
df -h
top

# Network diagnostics
ping -c 4 google.com
nslookup google.com
```

## Backup and Recovery

### Configuration Backup
- Export WSL2 distributions: `wsl --export Ubuntu C:\backup\ubuntu.tar`
- Backup `.wslconfig` file
- Document custom configurations

### Recovery Procedures
- Import WSL2 distribution: `wsl --import Ubuntu C:\wsl\ubuntu C:\backup\ubuntu.tar`
- Restore configuration files
- Reinstall Docker Desktop if needed

### Disaster Recovery
- Maintain offline backups of WSL2 images
- Document recovery time objectives
- Test recovery procedures regularly

## Advanced Configuration

### Custom Kernel
- Build custom WSL2 kernel for specific requirements
- Enable additional kernel modules
- Configure kernel parameters

### Multiple Distributions
- Install multiple Linux distributions
- Configure resource allocation per distribution
- Set up inter-distribution communication

### GPU Acceleration
- Enable GPU support for AI/ML workloads
- Configure CUDA in WSL2
- Monitor GPU utilization

## Best Practices

### Operational
- Regular updates of WSL2 and distributions
- Monitor resource usage trends
- Implement automated backups
- Document configuration changes

### Security
- Keep systems updated
- Use strong authentication
- Implement least privilege access
- Regular security assessments

### Performance
- Right-size resource allocation
- Implement monitoring and alerting
- Regular performance tuning
- Capacity planning

## Support Resources

### Microsoft Documentation
- WSL2 documentation: https://docs.microsoft.com/en-us/windows/wsl/
- WSL2 GitHub: https://github.com/microsoft/WSL

### Community Resources
- WSL2 subreddit: r/WSL2
- Docker forums for WSL2-specific issues
- Stack Overflow for troubleshooting

### Enterprise Support
- Microsoft support for WSL2 issues
- Docker Enterprise support
- Professional services for complex configurations