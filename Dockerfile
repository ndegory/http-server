FROM scratch
COPY httpd.linux /httpd
CMD ["/httpd"]
