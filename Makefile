# Makefile для генерации protobuf файлов

# Директории
PROTO_DIR = .
GO_OUT_DIR = ../road-detector-go/internal/proto
PYTHON_OUT_DIR = ../road-detector-py/proto

# Проверяем наличие protoc
check-protoc:
	@which protoc > /dev/null || (echo "protoc не найден. Установите Protocol Buffers compiler" && exit 1)
	@echo "✅ protoc найден"

# Создаем директории для выходных файлов
create-dirs:
	@mkdir -p $(GO_OUT_DIR)
	@mkdir -p $(PYTHON_OUT_DIR)
	@echo "📁 Создали директории для выходных файлов"

# Генерируем Go файлы
gen-go: check-protoc create-dirs
	@echo "🔄 Генерируем Go protobuf файлы..."
	protoc --go_out=$(GO_OUT_DIR) \
		   --go_opt=paths=source_relative \
		   --go-grpc_out=$(GO_OUT_DIR) \
		   --go-grpc_opt=paths=source_relative \
		   --proto_path=$(PROTO_DIR) \
		   road_marking.proto
	@echo "✅ Go файлы сгенерированы в $(GO_OUT_DIR)"

# Генерируем Python файлы
gen-python: check-protoc create-dirs
	@echo "🔄 Генерируем Python protobuf файлы..."
	protoc --python_out=$(PYTHON_OUT_DIR) \
		   --grpc_python_out=$(PYTHON_OUT_DIR) \
		   --proto_path=$(PROTO_DIR) \
		   road_marking.proto
	@echo "✅ Python файлы сгенерированы в $(PYTHON_OUT_DIR)"

# Генерируем все файлы
gen-all: gen-go gen-python
	@echo "🎉 Все protobuf файлы сгенерированы!"

# Очищаем сгенерированные файлы
clean:
	@rm -rf $(GO_OUT_DIR)
	@rm -rf $(PYTHON_OUT_DIR)
	@echo "🧹 Очистили сгенерированные файлы"

# Показываем помощь
help:
	@echo "Доступные команды:"
	@echo "  gen-all     - Генерирует protobuf файлы для Go и Python"
	@echo "  gen-go      - Генерирует только Go файлы"
	@echo "  gen-python  - Генерирует только Python файлы"
	@echo "  clean       - Удаляет сгенерированные файлы"
	@echo "  check-protoc - Проверяет наличие protoc"

.PHONY: check-protoc create-dirs gen-go gen-python gen-all clean help 