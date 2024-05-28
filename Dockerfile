FROM docker.io/library/ubuntu:18.04

# Update and install necessary packages
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install openjdk-8-jdk wget

# Create the Tomcat directory
RUN mkdir /usr/local/tomcat

# Download and extract Tomcat
RUN wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz -O /tmp/apache-tomcat-9.0.65.tar.gz && \
    tar -xvzf /tmp/apache-tomcat-9.0.65.tar.gz -C /usr/local/tomcat --strip-components=1 && \
    rm /tmp/apache-tomcat-9.0.65.tar.gz

# Copy the WAR files to the webapps directory
ADD **/*.war /usr/local/tomcat/webapps

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD /usr/local/tomcat/bin/catalina.sh run