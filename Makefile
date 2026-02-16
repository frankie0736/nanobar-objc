CC = clang
CFLAGS = -fobjc-arc -framework Cocoa -O2
TARGET = nanobar
PREFIX = /usr/local/bin

$(TARGET): main.m
	$(CC) $(CFLAGS) -o $@ $<

install: $(TARGET)
	cp $(TARGET) $(PREFIX)/$(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: install clean
