# Session 03 - Ex4: Nginx phục vụ 2 ứng dụng trên 2 cổng khác nhau

## Mục tiêu

Dùng một file cấu hình Nginx (`multi-port.conf`) với hai server block để phục vụ đồng thời:

| Ứng dụng     | Cổng | Web root                    |
|--------------|------|-----------------------------|
| Beta App     | 8080 | `/var/www/beta-app/html`     |
| Internal App | 8090 | `/var/www/internal-app/html` |

## Cấu trúc thư mục

```
ex4/
├── beta-app/index.html
├── internal-app/index.html
├── multi-port.conf
└── README.md
```

## Các bước thực hiện

### 1. Tạo 2 web root và trang index

```bash
sudo mkdir -p /var/www/beta-app/html /var/www/internal-app/html
sudo cp beta-app/index.html /var/www/beta-app/html/index.html
sudo cp internal-app/index.html /var/www/internal-app/html/index.html
sudo chown -R www-data:www-data /var/www/beta-app /var/www/internal-app
```

### 2. Tạo file cấu hình `multi-port.conf`

```bash
sudo cp multi-port.conf /etc/nginx/sites-available/multi-port.conf
```

(Hoặc `sudo nano /etc/nginx/sites-available/multi-port.conf` và dán nội dung file `multi-port.conf`.)

### 3. Tạo symlink sang `sites-enabled`

```bash
sudo ln -s /etc/nginx/sites-available/multi-port.conf /etc/nginx/sites-enabled/
```

### 4. Kiểm tra cú pháp cấu hình

```bash
sudo nginx -t
```

Kết quả mong đợi:

```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

### 5. Reload Nginx

```bash
sudo systemctl reload nginx
```

### 6. Mở cổng 8080 và 8090

Trên UFW:

```bash
sudo ufw allow 8080/tcp
sudo ufw allow 8090/tcp
sudo ufw status
```

Trên firewall của nhà cung cấp VPS (Security Group / Network Firewall trên trang quản trị): thêm rule cho phép inbound TCP cổng **8080** và **8090**.

## Kiểm tra

### Test 1: Beta App (cổng 8080)

```bash
curl http://<IP_VPS>:8080
```

Kết quả mong đợi: trả về HTML chứa

```html
<title>Beta App</title>
<h1>Beta App</h1>
<p>Welcome to the Beta testing environment (port 8080).</p>
```

### Test 2: Internal App (cổng 8090)

```bash
curl http://<IP_VPS>:8090
```

Kết quả mong đợi: trả về HTML chứa

```html
<title>Internal App</title>
<h1>Internal App</h1>
<p>Internal information portal (port 8090).</p>
```

## Ảnh chụp màn hình

<!-- Thay các dòng dưới bằng ảnh thật, ví dụ: ![nginx -t](images/nginx-t.png) -->

- [ ] `sudo nginx -t`: _(chèn ảnh)_
- [ ] `sudo ufw status`: _(chèn ảnh)_
- [ ] `curl http://<IP_VPS>:8080`: _(chèn ảnh)_
- [ ] `curl http://<IP_VPS>:8090`: _(chèn ảnh)_
- [ ] Mở trình duyệt `http://<IP_VPS>:8080` và `http://<IP_VPS>:8090`: _(chèn ảnh)_
