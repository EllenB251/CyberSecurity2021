# Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![Project-1](https://github.com/EllenB251/CyberSecurity2021/blob/ac35fa0342f4e8bc4a526db4b98dcb1a4b784cc2/Diagrams/Ellen%20Brookes%20Project-1.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above, or, alternatively, select portions of the playbook YAML may be used to install only certain pieces of it, such as filebeat.

  Playbook 1 - pentest.yml
  ``` 
  ---
- name: Config Web VM with Docker
  hosts: webservers
  become: true
  tasks:

    - name: Install docker.io
      apt:
        update_cache: yes
        name: docker.io
        state: present

    - name: Install pip3
      apt:
        name: python3-pip
        state: present

    - name: Install python Docker Module
      pip:
        name: docker
        state: present

    - name: Download and launch a docker web container
      docker_container:
        name: dvwa
        image: cyberxsecurity/dvwa
        state: started
        restart_policy: always
        published_ports: 80:80

    - name: Enable Docker Service
      systemd:
        name: docker
        enabled: yes
  ```

  Playbook 2 - install-elk.yml
  ```
  ---
- name: Configure Elk VM with Docker
  hosts: elk
  remote_user: azadmin
  become: true
  tasks:

    - name: Install docker.io
      apt:
        update_cache: yes
        force_apt_get: yes
        name: docker.io
        state: present

    - name: Install pip3
      apt:
        force_apt_get: yes
        name: python3-pip
        state: present

    - name: Install Docker module
      pip:
        name: docker
        state: present

    - name: Increase virtual memory
      command: sysctl -w vm.max_map_count=262144

    - name: Use more memory
      sysctl:
        name: vm.max_map_count
        value: '262144'
        state: present
        reload: yes

    - name: download and launch a docker elk container
      docker_container:
        name: elk
        image: sebp/elk:761
        state: started
        restart_policy: always
        published_ports:
          -  5601:5601
          -  9200:9200
          -  5044:5044
  ```

  Playbook 3 - filebeat-playbook.yml
  ```
  ---
- name: installing and launching filebeat
  hosts: webservers
  become: yes
  tasks:

  - name: download filebeat deb
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.1-amd64.deb

  - name: install filebeat deb
    command: dpkg -i filebeat-7.6.1-amd64.deb

  - name: drop in filebeat.yml
    copy:
      src: /etc/ansible/filebeat-config.yml
      dest: /etc/filebeat/filebeat.yml

  - name: enable and configure system module
    command: filebeat modules enable system

  - name: setup filebeat
    command: filebeat setup

  - name: start filebeat service
    command: service filebeat start

  - name: enable service filebeat on boot
    systemd:
      name: filebeat
      enabled: yes
  ```

  Playbook 4 - metricbeat-playbook.yml
  ``` ---
- name: Install metric beat
  hosts: webservers
  become: true
  tasks:
  
  - name: Download metricbeat
    command: curl -L -O curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.6.1-amd64.deb

  - name: install metricbeat
    command: dpkg -i metricbeat-7.6.1-amd64.deb

  - name: drop in metricbeat config
    copy:
      src: /etc/ansible/metricbeat-config.yml
      dest: /etc/metricbeat/metricbeat.yml

  - name: enable and configure docker module for metric beat
    command: metricbeat modules enable docker

  - name: setup metric beat
    command: metricbeat setup

  - name: start metric beat
    command: sudo service metricbeat start

  - name: enable service metricbeat on boot
    systemd:
      name: metricbeat
      enabled: yes
  ```

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


## Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting traffic to the network.
- Load balancers ensure application availability and protect redundancy, sharing client requests across a number of servers and stopping one server becoming overloaded with traffic.
- The Jump Box server adds the advantage of further limitng the attack surface and providing a easy vatage point for monitoring suspicious connections by ensuring traffic to the cloud network is filtered through a single virtual machine.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the configuration and system files.
- Filebeat is used to capture and send log files from the VMs in which it is installed to a remote editing system
-  Metricbeat collects and sends service and operating system statistics from these monitored VMs to the auditing server.

The configuration details of each machine may be found below.

| Name      | Function | IP Address | Operating System |
|-----------|----------|------------|------------------|
| Jump Box  | Gateway  | 10.0.0.4   | Linux  - Ubuntu  |
| Web-1     | DVWA     | 10.0.0.5   | Linux - Ubuntu   |
| Web-2     | DVWA     | 10.0.0.6   | Linux - Ubuntu   |
| Web-3     | DVWA     | 10.0.0.7   | Linux - Ubuntu   |
| ELKServer | ELK      | 10.1.0.4   | Linux - Ubuntu   |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jump Box machine can accept SSH connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- Personal Home Network IP

Machines within the network can only be accessed by the Jump Box within the Ansible Container.
- The Jump Box can also access the ELK Virtual Machine ELKServer using SSH from the internal IP address 10.0.0.4

A summary of the access policies in place can be found in the table below.

| Name      | Publicly Accessible      | Allowed IP Addresses                |
|-----------|--------------------------|------------------------------------ |
| Jump Box  | Yes                      | Personal Home Network IP            |
| Web-1     | No (HTTP from Home ONLY) | 10.0.0.4 / Home IP for DVWA HTTP    |
| Web-2     | No (HTTP from Home ONLY) | 10.0.0.4 / Home IP for DVWA HTTP    |
| Web-3     | No (HTTP from Home ONLY) | 10.0.0.4 / Home IP for DVWA HTTP    |
| ELKServer | No (but has Public IP)   | 10.0.0.4 / Home IP for ELK APP HTTP |

### ELK Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because:
- By automating the build and deployment stages of configuration , it is guaranteed to be performed automatically, consistently, and with speed, simplifying repetitive, complex, and often tedious tasks. Given its automatiion, it can also facilitate OS and software updates, and apply scripted security measures across the board.

The elk-install.yml playbook implements the following tasks:
- Installs Docker
- Installs Python
- Installs Docker's Python Module
- Increases virtual memory to support the ELK stack
- Downloads and launches the Docker ELK container

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![Docker Success](https://github.com/EllenB251/CyberSecurity2021/blob/e7507e71256ddcc1622128ff98e74c9c2804cc01/Diagrams/docker_ps_success.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- Web-1: 10.0.0.5
- Web-2: 10.0.0.6
- Web-3: 10.0.0.7

We have installed the following Beats on these machines:
- Filebeat
- Metricbeat

These Beats allow us to collect the following information from each machine:
- Filebeat gathers and sends logs from the VMs running the Filebeat agent to the ELK server for analysis and reporting
- Metricbeat gathers metrics from the operating system and services of the VMs running the Metricbeat agent and sends them to the ELK server for analysis.

### Using the Playbook
In order to use the playbooks referred to above, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the playbook YAML file to the Ansible container.
- Update the Ansible hosts `/etc/ansible/hosts` file to include the following:
```
[webservers]
10.0.0.5 ansible_python_interpreter=/usr/bin/python3
10.0.0.6 ansible_python_interpreter=/usr/bin/python3
10.0.0.7 ansible_python_interpreter=/usr/bin/python3

[elk]
10.1.0.4 ansible_python_interpreter=/usr/bin/python3
```
- Update the Ansible configuration file `/etc/ansible/ansible.cfg` and set the remote_user parameter to the admin user of the web servers.

- Begin an SSH session with the Jump Box  `ssh (admin_user)@(Jump Box Public IP)`

- Start the Ansible container `sudo docker start (ansible-container-name)`

- Attach a shell to the Ansible Docker container with the command `sudo docker attach (ansible-container-name)`

- Run the playbook using the command 
`ansible-playbook (name-of-playbook).yml`

  - Note: The hosts line of the install-elk playbook is configured to only affect the ELK server, while the Filebeat and Metricbeat playbooks have the hosts set to webservers.

- Once the playbooks have been run and no errors could be found in the output, navigate to Kibana to check that the installation worked as expected by checking the Filebeat and Metricbeat data and reports in the Dashboard.
- Kibana can be accessed at [http://{elk-server-ip}:5601/app/kibana](http://<elk-server-ip>:5601/app/kibana) 
