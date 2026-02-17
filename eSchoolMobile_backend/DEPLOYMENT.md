# Guide de Déploiement eSchoolMobile sur Plesk

## Prérequis sur le VPS

1. **Python 3.11+** installé
2. **MySQL** (via Plesk)
3. **SSH access**

---

## Étape 1: Créer la base MySQL dans Plesk

1. Connectez-vous à Plesk: `https://87.106.23.108:8443`
2. Allez dans **Databases** > **Add Database**
3. Créez:
   - Database name: `db_eschoolmobile`
   - User: `eschoolmobile_user`
   - Password: (notez-le pour le `.env`)

---

## Étape 2: Déployer via SSH

```bash
# Connectez-vous au VPS
ssh root@87.106.23.108

# Créer le dossier de l'application
mkdir -p /var/www/eschoolmobile
cd /var/www/eschoolmobile

# Cloner le repo (ou uploader les fichiers)
git clone https://github.com/ictgroup-entreprise/eSchoolMobile_mobileApp_back.git .

# Créer l'environnement virtuel
python3 -m venv venv
source venv/bin/activate

# Installer les dépendances
pip install -r requirements.txt

# Copier et configurer .env
cp .env.example .env
nano .env  # Modifier avec vos vraies valeurs

# Appliquer les migrations
python manage.py migrate

# Collecter les fichiers statiques
python manage.py collectstatic --noinput

# Tester le serveur
python manage.py runserver 0.0.0.0:8000
```

---

## Étape 3: Configurer Gunicorn comme service

Créer `/etc/systemd/system/eschoolmobile.service`:

```ini
[Unit]
Description=eSchoolMobile Django API
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/var/www/eschoolmobile
Environment="PATH=/var/www/eschoolmobile/venv/bin"
ExecStart=/var/www/eschoolmobile/venv/bin/gunicorn --workers 3 --bind 0.0.0.0:8000 monecole_ws.wsgi:application

[Install]
WantedBy=multi-user.target
```

Activer le service:
```bash
sudo systemctl daemon-reload
sudo systemctl enable eschoolmobile
sudo systemctl start eschoolmobile
sudo systemctl status eschoolmobile
```

---

## Étape 4: Configurer Nginx (optionnel - proxy HTTPS)

Dans Plesk, configurez un domaine ou sous-domaine avec proxy vers `localhost:8000`.

Ou manuellement, créer `/etc/nginx/sites-available/eschoolmobile`:

```nginx
server {
    listen 80;
    server_name 87.106.23.108;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /static/ {
        alias /var/www/eschoolmobile/staticfiles/;
    }

    location /media/ {
        alias /var/www/eschoolmobile/media/;
    }
}
```

---

## Étape 5: Ouvrir le port 8000

```bash
# Si UFW est actif
sudo ufw allow 8000

# Ou via iptables
sudo iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
```

---

## Vérification

```bash
curl http://87.106.23.108:8000/annees_scolaires
```

Devrait retourner la liste des années scolaires (ou une erreur 401 si auth requise).
