include:
  - nginx.install

nginx-init:
  file.managed:
    - name: /etc/init.d/nginx
    - source: salt://nginx/files/nginx-init
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: chkconfig nginx on
    - unless: chkconfig --list | grep nginx
    - require:
      - file: nginx-init

nginx-conf:
  file.managed:
    - name: /opt/nginx/conf/nginx.conf
    - source: salt://nginx/files/nginx.conf
    - user: www
    - group: www
    - mode: 644 

nginx-service:
  file.directory:
    - name: /opt/nginx/conf/vhost
    - require:
      - cmd: nginx-install
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - require:
      - cmd: nginx-init
    - watch:
      - file: /opt/nginx/conf/nginx.conf
