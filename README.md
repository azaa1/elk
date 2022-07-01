# ELK Stack
ELK Stack on Ubuntu 20.04 (LTS)

## What is ELK Stack? 
ELK Stack is a collection of open-source software that allows the user to search, analyze, and visualize logs. The generation of logs is from any source in any format, a practice called centralized logging.

### Important Components of ELK Stack

- **Elasticsearch:** It is a distribution of restful search engine which allows storing of all of the collected data.
- **Logstash:** It is a data processing component of the Elastic Stack, it sends the incoming data to Elasticsearch.
- **Kibana:** A web interface for searching as well as visualizing logs.
- **Beats:** This is a lightweight, single-purpose data shipper. It sends data from thousands of machines to Logstash or Elasticsearch.

<p align="center">
  <img src="images/elk.png" width="500" height="200" title="elk">
</p>

## Prerequisites
### Server Type / Size
- Ubuntu 20.04 
- 4GB RAM / 2 CPUs

### Packages
- OpenJDK 11
- Nginx

## How to use this repository to install ELK Stack? 

### Run Installation Scripts: 

- Clone Repository
```
git clone https://github.com/azaa1/elk.git
```

- Run OpenJDK 11 Installation
```
sudo bash elk/scripts/install_openjdk11.sh 
```

- Run Nginx Installation
```
sudo bash elk/scripts/install_nginx.sh 
```

- Run ELK Installation
```
sudo bash elk/scripts/install_elk.sh
```

### Post Installation Configuration:
> **NOTE:** <span style="color:LightSkyBlue ;">
    The configuration of Kibana is only to listen on localhost. You will need to set up a reverse proxy to allow external access.
</span>

- Using ``openssl`` create an adminstrative Kibana user.

  - Enter and confirm a password at the prompt.

  ```
  echo "kibanaadmin:`openssl passwd -apr1`" | sudo tee -a /etc/nginx/htpasswd.users
  ```  

- Create an Nginx server block file.
  ```
  sudo vi /etc/nginx/sites-available/elk
  ```

  - Add the below code block into the file. Be sure to update your_domain to match your server’s FQDN or public IP-address. This code will configure Nginx to direct the server’s HTTP traffic to Kibana application. Moreover, it is also listening on localhost:5601. Also, it configures Nginx to read the htpasswd.users file. It will need basic authentication.
  ```
  server {
    listen 80;

    server_name your_domain;  #< your domain or ip here

    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/htpasswd.users;

    location / {
        proxy_pass http://localhost:5601;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
  }
  ```

  - Then enable a new configuration by creating a symbolic-link to sites-enabled directory.
  ```
  sudo ln -s /etc/nginx/sites-available/elk /etc/nginx/sites-enabled/elk
  ```

  - Check the configuration for syntax errors.
  ```
  sudo nginx -t
  ```

  - Reload Nginx service.
  ```
  sudo systemctl reload nginx
  ```

  - Allow UFW firewall connections to Nginx.
  ```
  sudo ufw allow 'Nginx Full'
  ```

  -  Kibana is now accessible from your FQDN or public IP address of your Elastic Stack server. Navigate to the address and enter login credentials when prompted.

### Installing and Configuring the Logstash:
> **NOTE:** A Logstash pipeline has two necessary elements, ``input`` and ``output``, and one optional element the ``filter``. The ``input`` plugin consumes the data from a source, the ``filter`` plugins processes the data and the ``output`` plugins write the data to the destination.

<p align="center">
  <img src="images/logstash.png" width="500" height="200" title="elk">
</p>

### Run Installation Scripts: 

- Run Logstash Installation
```
sudo bash elk/scripts/install_logstash.sh 
```

- Create a configuration file for Filebeat input. 
```
sudo vi /etc/logstash/conf.d/02-beats-input.conf
```

- And add following ``input`` configuration. This specifies beats ``input`` that will listen on TCP-port 5044.
```
input {
  beats {
    port => 5044
  }
}
```

- Create an ``output`` configuration file called ``30-elasticsearch-output.conf``. 
```
sudo vi /etc/logstash/conf.d/30-elasticsearch-output.conf
```
- And add the following ``output`` configuration. 
```
output {
  if [@metadata][pipeline] {
    elasticsearch {
    hosts => ["localhost:9200"]
    manage_template => false
    index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
    pipeline => "%{[@metadata][pipeline]}"
    }
  } else {
    elasticsearch {
    hosts => ["localhost:9200"]
    manage_template => false
    index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
    }
  }
}
```

- Check Logstash configuration 
```
sudo -u logstash /usr/share/logstash/bin/logstash --path.settings /etc/logstash -t
```

- If the configuration is OK, start and enable logstash. 
```
sudo bash elk/scripts/start_enable_logstash.sh
```

- Logstash is running and configuration done.


### Installing and Configuring the Filebeat:

