FROM tesztsorta/priv:training_portal_frontend_v0_9_0 as build_frontend

FROM nginx:latest

# frontend
COPY --from=build_frontend /home/app/dist /usr/share/nginx/html/frontend
RUN chown -R nginx:nginx /usr/share/nginx/html/frontend
RUN chmod -R 755 /usr/share/nginx/html/frontend

# ssl
#COPY --chmod=644 --chown=nginx:nginx  ssl/training-portal-cert /etc/nginx/ssl/training-portal.crt
#COPY --chmod=600 --chown=nginx:nginx  ssl/training-portal-key /etc/nginx/ssl/training-portal.key

# config
COPY --chown=nginx:nginx --chmod=644 nginx/nginx.conf /etc/nginx/templates/default.conf.template
RUN envsubst '$DOMAIN' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf
