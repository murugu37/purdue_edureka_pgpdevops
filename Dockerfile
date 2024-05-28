FROM ubuntu:18.04

# Update and install necessary packages
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install openjdk-8-jdk wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a directory for Tomcat
RUN mkdir /usr/local/tomcat

# Download and extract Tomcat
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.86/bin/apache-tomcat-9.0.86.tar.gz -O /tmp/apache-tomcat-9.0.86.tar.gz && \
    tar -xvzf /tmp/apache-tomcat-9.0.86.tar.gz -C /usr/local/tomcat --strip-components=1 && \
    rm /tmp/apache-tomcat-9.0.86.tar.gz

# Add WAR files to the webapps directory
COPY **/*.war /usr/local/tomcat/webapps/

# Expose the necessary port
EXPOSE 8080

# Start Tomcat
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
