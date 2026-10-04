# FoodX – Kho cấu hình tập trung (Spring Cloud Config)

Repository này là **config repo** cho Spring Cloud Config Server của hệ thống FoodX.
Config Server đọc các file YAML ở đây và phục vụ cấu hình cho từng microservice khi
service khởi động.

## 1. Cấu trúc thư mục

```
.
├── restaurant-service.yml   # cấu hình cho service có spring.application.name = restaurant-service
├── order-service.yml        # cấu hình cho service có spring.application.name = order-service
└── delivery-service.yml     # cấu hình cho service có spring.application.name = delivery-service
```

Mỗi service có **đúng một** file YAML. Cấu trúc các file giống hệt nhau
(`spring.datasource`, `server.port`) để dễ so sánh và bảo trì.

### Vì sao tên file phải trùng khớp `spring.application.name`?

Config Server ánh xạ request theo tên ứng dụng, dùng quy tắc:

```
{application}.yml
{application}-{profile}.yml
```

Khi service `order-service` khởi động, nó gọi Config Server và Config Server
tìm file `order-service.yml`. Nếu tên file **không khớp** (ví dụ đặt là `config.yml`
hoặc `orders-service.yml`):

- Config Server **không tìm thấy** file nào phù hợp và trả về cấu hình rỗng.
- Service **không báo lỗi** – nó chỉ chạy với giá trị mặc định / rỗng.
- Hậu quả: thiếu URL datasource, sai port, ứng dụng lỗi lúc runtime mà rất khó
  lần ra nguyên nhân.

Vì vậy: **tên file = giá trị `spring.application.name` của service, không hơn không kém.**

## 2. Không bao giờ lưu mật khẩu ở dạng plaintext

Git lưu lại **toàn bộ lịch sử**. Một mật khẩu commit nhầm vẫn còn trong history
kể cả sau khi đã xóa ở commit sau. Do đó repo này **chỉ chứa giá trị đã mã hóa**.

Spring Cloud Config hỗ trợ cú pháp `{cipher}`:

```yaml
password: '{cipher}AQBv...=='
```

- Giá trị sau `{cipher}` là **ciphertext** (đã mã hóa bằng khóa của Config Server).
- Khi client xin cấu hình, Config Server **tự giải mã tại chỗ** rồi mới trả về
  giá trị plaintext qua kết nối tới client.
- Nhờ vậy, **chỉ có bản mã** tồn tại trong Git repo và trong lịch sử của nó.
- Chuỗi `{cipher}` phải để trong dấu nháy đơn để YAML không hiểu nhầm `{` là map.

Config Server cần được cấu hình khóa giải mã (`encrypt.key` đối xứng hoặc keystore
bất đối xứng) thì cơ chế này mới hoạt động.

## 3. Lưu ý về giá trị `{cipher}` trong repo này

Các giá trị `{cipher}...==` hiện tại **chỉ mang tính minh họa** cho đúng định dạng,
**không phải** ciphertext thật và không giải mã được.

Trước khi dùng thật, phải thay từng giá trị bằng ciphertext thật sinh ra từ endpoint
`/encrypt` của Config Server:

```bash
curl -s http://localhost:8888/encrypt -d 'MatKhauThatCuaBan'
# -> dán kết quả vào sau {cipher} trong file YAML tương ứng
```
