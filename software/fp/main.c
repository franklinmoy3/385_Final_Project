//ECE 385 USB Host Shield code
//based on Circuits-at-home USB Host code 1.x
//to be used for ECE 385 course materials
//Revised October 2020 - Zuofu Cheng

#include <stdio.h>
#include "system.h"
#include "altera_avalon_spi.h"
#include "altera_avalon_spi_regs.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"
#include "usb_kb/GenericMacros.h"
#include "usb_kb/GenericTypeDefs.h"
#include "usb_kb/HID.h"
#include "usb_kb/MAX3421E.h"
#include "usb_kb/transfer.h"
#include "usb_kb/usb_ch9.h"
#include "usb_kb/USB.h"

extern HID_DEVICE hid_device;

static BYTE addr = 1; 				//hard-wired USB address
const char* const devclasses[] = { " Uninitialized", " HID Keyboard", " HID Mouse", " Mass storage" };

BYTE GetDriverandReport() {
	BYTE i;
	BYTE rcode;
	BYTE device = 0xFF;
	BYTE tmpbyte;

	DEV_RECORD* tpl_ptr;
	printf("Reached USB_STATE_RUNNING (0x40)\n");
	for (i = 1; i < USB_NUMDEVICES; i++) {
		tpl_ptr = GetDevtable(i);
		if (tpl_ptr->epinfo != NULL) {
			printf("Device: %d", i);
			printf("%s \n", devclasses[tpl_ptr->devclass]);
			device = tpl_ptr->devclass;
		}
	}
	//Query rate and protocol
	rcode = XferGetIdle(addr, 0, hid_device.interface, 0, &tmpbyte);
	if (rcode) {   //error handling
		printf("GetIdle Error. Error code: ");
		printf("%x \n", rcode);
	} else {
		printf("Update rate: ");
		printf("%x \n", tmpbyte);
	}
	printf("Protocol: ");
	rcode = XferGetProto(addr, 0, hid_device.interface, &tmpbyte);
	if (rcode) {   //error handling
		printf("GetProto Error. Error code ");
		printf("%x \n", rcode);
	} else {
		printf("%d \n", tmpbyte);
	}
	return device;
}

void setLED(int LED) {
	IOWR_ALTERA_AVALON_PIO_DATA(LEDS_PIO_BASE,
			(IORD_ALTERA_AVALON_PIO_DATA(LEDS_PIO_BASE) | (0x001 << LED)));
}

void clearLED(int LED) {
	IOWR_ALTERA_AVALON_PIO_DATA(LEDS_PIO_BASE,
			(IORD_ALTERA_AVALON_PIO_DATA(LEDS_PIO_BASE) & ~(0x001 << LED)));

}

void printSignedHex0(signed char value) {
	BYTE tens = 0;
	BYTE ones = 0;
	WORD pio_val = IORD_ALTERA_AVALON_PIO_DATA(HEX_DIGITS_PIO_BASE);
	if (value < 0) {
		setLED(11);
		value = -value;
	} else {
		clearLED(11);
	}
	//handled hundreds
	if (value / 100)
		setLED(13);
	else
		clearLED(13);

	value = value % 100;
	tens = value / 10;
	ones = value % 10;

	pio_val &= 0x00FF;
	pio_val |= (tens << 12);
	pio_val |= (ones << 8);

	IOWR_ALTERA_AVALON_PIO_DATA(HEX_DIGITS_PIO_BASE, pio_val);
}

void printSignedHex1(signed char value) {
	BYTE tens = 0;
	BYTE ones = 0;
	DWORD pio_val = IORD_ALTERA_AVALON_PIO_DATA(HEX_DIGITS_PIO_BASE);
	if (value < 0) {
		setLED(10);
		value = -value;
	} else {
		clearLED(10);
	}
	//handled hundreds
	if (value / 100)
		setLED(12);
	else
		clearLED(12);

	value = value % 100;
	tens = value / 10;
	ones = value % 10;
	tens = value / 10;
	ones = value % 10;

	pio_val &= 0xFF00;
	pio_val |= (tens << 4);
	pio_val |= (ones << 0);

	IOWR_ALTERA_AVALON_PIO_DATA(HEX_DIGITS_PIO_BASE, pio_val);
}

void setKeycode(unsigned pioIndex, WORD keycode)
{
	switch (pioIndex) {
		// Player 1 movement
		case 0:
			IOWR_ALTERA_AVALON_PIO_DATA(KEYCODE_BASE, keycode);
			break;
		// Player 2 movement
		case 1:
			IOWR_ALTERA_AVALON_PIO_DATA(KEYCODE_1_BASE, keycode);
			break;
		// Player 1 fire button
		case 2:
			IOWR_ALTERA_AVALON_PIO_DATA(KEYCODE_2_BASE, keycode);
			break;
		// Player 2 fire button
		case 3:
			IOWR_ALTERA_AVALON_PIO_DATA(KEYCODE_3_BASE, keycode);
			break;
		default: 
			printf("Input pioIndex %u out of range.", pioIndex);
			break;
	}
}
int main() {
	BYTE rcode;
	BOOT_MOUSE_REPORT buf;		//USB mouse report
	BOOT_KBD_REPORT kbdbuf;

	BYTE runningdebugflag = 0;//flag to dump out a bunch of information when we first get to USB_STATE_RUNNING
	BYTE errorflag = 0; //flag once we get an error device so we don't keep dumping out state info
	BYTE device;
	WORD keystrokeMap[6]; // Indicates if the KB_buf index is player 1 (1 or 3), player 2 (2 or 4), or released (0)

	printf("initializing MAX3421E...\n");
	MAX3421E_init();
	printf("initializing USB...\n");
	USB_init();
	// Initialize keycode buffers
	for(int i = 0; i < 6; i++) {
		kbdbuf.keycode[i] = 0;
		keystrokeMap[i] = 4;
	}
	while (1) {
		printf(".");
		MAX3421E_Task();
		USB_Task();
		//usleep (500000);
		if (GetUsbTaskState() == USB_STATE_RUNNING) {
			if (!runningdebugflag) {
				runningdebugflag = 1;
				setLED(9);
				device = GetDriverandReport();
			} else if (device == 1) {
				//run keyboard debug polling
				rcode = kbdPoll(&kbdbuf);
				if (rcode == hrNAK) {
					// We want to continuously poll, so read even if there is no new data
				} else if (rcode) {
					printf("Rcode: ");
					printf("%x \n", rcode);
					continue;
				}
				printf("keycodes: ");
				
				// Workaround for allowing players to hold down keys without interfering 
				//  with the other player's mapping by resetting all keycode PIOs
				for (int i = 0; i < 4; i++) {
					setKeycode(i, 0);
				}
				
				for (int i = 0; i < 6; i++) {
					printf("%x ", kbdbuf.keycode[i]);

					// Read keycodes and redirect assignments
					switch (kbdbuf.keycode[i]) {
						// Player 1 movement (WASD, respectively)
						case 26:
							keystrokeMap[i] = 0;
							setKeycode(0, kbdbuf.keycode[i]);
							break;
						case 4:
							keystrokeMap[i] = 0;
							setKeycode(0, kbdbuf.keycode[i]);
							break;
						case 22:
							keystrokeMap[i] = 0;
							setKeycode(0, kbdbuf.keycode[i]);
							break;
						case 7:
							keystrokeMap[i] = 0;
							setKeycode(0, kbdbuf.keycode[i]);
							break;
						// Player 2 movement (Up, Left, Down, Right arrow keys, respectively)
						case 82:
							keystrokeMap[i] = 1;
							setKeycode(1, kbdbuf.keycode[i]);
							break;
						case 80:
							keystrokeMap[i] = 1;
							setKeycode(1, kbdbuf.keycode[i]);
							break;
						case 81:
							keystrokeMap[i] = 1;
							setKeycode(1, kbdbuf.keycode[i]);
							break;
						case 79:
							keystrokeMap[i] = 1;
							setKeycode(1, kbdbuf.keycode[i]);
							break;
						// Player 1 fire (spacebar)
						case 44:
							keystrokeMap[i] = 2;
							setKeycode(2, kbdbuf.keycode[i]);
							break;
						// Player 2 fire (keypad enter)
						case 88:
							keystrokeMap[i] = 3;
							setKeycode(3, kbdbuf.keycode[i]);
							break;
						// Key releases (could cause movement jitters or stops when released if holding multiple direction buttons)
						case 0:
							switch (keystrokeMap[i]) {
								case 0:
									setKeycode(0, 0);
									break;
								case 1:
									setKeycode(1, 0);
									break;
								case 2:
									setKeycode(2, 0);
									break;
								case 3:
									setKeycode(3, 0);
									break;
								case 4:
									break;
								default:
									printf("LMAO u fucked up the keystrokeMap!");
									break; 
							}
							keystrokeMap[i] = 4;
							break;
						default:
							break;
					}
				}
				// setKeycode(kbdbuf.keycode[0]);
				// printSignedHex0(kbdbuf.keycode[0]);
				// printSignedHex1(kbdbuf.keycode[1]);
				printf("\n");
			}

			else if (device == 2) {
				rcode = mousePoll(&buf);
				if (rcode == hrNAK) {
					//NAK means no new data
					continue;
				} else if (rcode) {
					printf("Rcode: ");
					printf("%x \n", rcode);
					continue;
				}
				printf("X displacement: ");
				printf("%d ", (signed char) buf.Xdispl);
				printSignedHex0((signed char) buf.Xdispl);
				printf("Y displacement: ");
				printf("%d ", (signed char) buf.Ydispl);
				printSignedHex1((signed char) buf.Ydispl);
				printf("Buttons: ");
				printf("%x\n", buf.button);
				if (buf.button & 0x04)
					setLED(2);
				else
					clearLED(2);
				if (buf.button & 0x02)
					setLED(1);
				else
					clearLED(1);
				if (buf.button & 0x01)
					setLED(0);
				else
					clearLED(0);
			}
		} else if (GetUsbTaskState() == USB_STATE_ERROR) {
			if (!errorflag) {
				errorflag = 1;
				clearLED(9);
				printf("USB Error State\n");
				//print out string descriptor here
			}
		} else //not in USB running state
		{

			printf("USB task state: ");
			printf("%x\n", GetUsbTaskState());
			if (runningdebugflag) {	//previously running, reset USB hardware just to clear out any funky state, HS/FS etc
				runningdebugflag = 0;
				MAX3421E_init();
				USB_init();
			}
			errorflag = 0;
			clearLED(9);
		}

	}
	return 0;
}
