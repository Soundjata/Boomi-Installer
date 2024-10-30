FROM --platform=linux/arm64 sonarqube:community

USER root
# Install sonarqube scanner.  
WORKDIR /opt/sonarqube  

RUN apt-get update
RUN apt-get --no-install-recommends -y install unzip
RUN curl -s https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip -o sonar-scanner-cli-4.2.0.1873-linux.zip

RUN unzip sonar-scanner-cli-4.2.0.1873-linux.zip  
RUN rm sonar-scanner-cli-4.2.0.1873-linux.zip  
ENV PATH=${PATH}:/opt/sonarqube/sonar-scanner-4.2.0.1873-linux/bin


RUN mkdir /home/.sonar
RUN chmod 777 /home/.sonar
ENV SONAR_USER_HOME=/home/.sonar

USER sonarqube
