package com.robotkit;// 15_07_2015 ROBOTKIT

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.FloatBuffer;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.UUID;



import android.app.Activity;
import android.app.AlertDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.SystemClock;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.View.OnTouchListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends Activity {
	// ================= MA LENH DUNG DIEU KHIEN QUA BLUETOOTH
	// ===============================

	private static final int OCM_OUTPUT1 = 111;
	private static final int OCM_OUTPUT2 = 112;
	private static final int OCM_OUTPUT3 = 113;
	private static final int OCM_OUTPUT4 = 114;

	// /========================= Bien dung cho imput
	// data=========================
	public static final int REQUEST_CODE_INPUT = 113;
	public static final int RESULT_CODE_SAVE1 = 115;
	public static final int RESULT_CODE_SAVE2 = 116;
	static int inputCode = 0;
	static int flagInput = 0;
	static String inputLoad;
	static String inputTitle;
	// ========================= KHAI BAO BIEN TOAN CỤC
	// ==========================
	static int pro = 0, m = 0, km = 0, fhut = 0, fxa = 0, fbt = 0, nchai = 0,
			dm1 = 0, dm2 = 0, dm3 = 0, dm4 = 0, dm5 = 0, dm6 = 0, dm7 = 0,
			dm8 = 0, kx = 0;
	static boolean flagTestMachine = false; // bien bao lan dau tien run
	static float matkhau = 0;

	// ========================== SET UP BLUETOOTH
	// ==============================
	// ============================ cac bien can thiet de khoi dong
	// bluetooth====================================
	private static final int REQUEST_ENABLE_BT = 10;
	// Default UUID used to connect to the HC-05 bluetooth module.
	// Do not change this UUID
	private static final UUID MY_UUID = UUID
			.fromString("00001101-0000-1000-8000-00805F9B34FB");
	// Message types sent from the Bluetooth Handler
	public static final int MESSAGE_SENT = 1;
	public static final int MESSAGE_RECEIVED = 2;
	public static final int CONNECTED = 3;
	public static final int MESSAGE_CLIMODE = 4;
	public static final int MESSAGE_TIMER_TASK = 5;

	private static String deviceBt;

	private BroadcastReceiver mReceiver = null;

	// Variable used to determine if the device is connected to the bt device
	static boolean connected = false;
	private AlertDialog.Builder builder;

	BluetoothDevice bluetoothHC05;

	static BluetoothAdapter mBluetoothAdapter;
	private ArrayList<String> btResult = new ArrayList<String>();
	private ArrayList<BluetoothDevice> btResultDevices = new ArrayList<BluetoothDevice>();
	private ArrayAdapter<String> adapter;
	private IntentFilter filter, f1, f2;
	private ConnectThread ct;
	private static ConnectedThread ctd;
	private static final String MSP_HEADER = "$M<"; // header cua frame truyen
													// via bluetooth

	// ==============================HAM SU DUNG DE REQUEST DU
	// LIEU==========================
	// send msp without payload
	static List<Byte> requestMSP(int msp) {
		return requestMSP(msp, null);
	}

	// send multiple msp without payload
	private List<Byte> requestMSP(int[] msps) {
		List<Byte> s = new LinkedList<Byte>();
		for (int m : msps) {
			s.addAll(requestMSP(m, null));
		}
		return s;
	}

	// send msp with payload
	static List<Byte> requestMSP(int msp, Character[] payload) {
		if (msp < 0) {
			return null;
		}
		// ADD HEADER $M<
		List<Byte> bf = new LinkedList<Byte>();
		for (byte c : MSP_HEADER.getBytes()) {
			bf.add(c);
		}

		// //ADD SIZE DATA 1BYTE
		// byte checksum=0;
		// byte pl_size = (byte)((payload != null ? (int)(payload.length) :
		// 0)&0xFF);
		// bf.add(pl_size);
		// checksum ^= (pl_size&0xFF);
		// //ADD SIZE DATA 1BYTE

		// ADD SIZE DATA 2 BYTE
		byte checksum = 0;
		// BYTE THAP
		// if(payload != null ){byte pl_size= (byte)
		// ((byte)((int)(payload.length))&0xFF);}else{byte pl_size=0&0xFF;}
		byte pl_size = (byte) ((payload != null ? (int) (payload.length) : 0) & 0xFF);
		bf.add(pl_size);
		checksum ^= (pl_size & 0xFF);

		// BYTE CAO
		pl_size = (byte) ((payload != null ? (int) (payload.length) >> 8 : 0) & 0xFF);
		bf.add(pl_size);
		checksum ^= (pl_size & 0xFF);
		// ADD SIZE DATA 2 BYTE

		// BYTE MA LENH
		// bf.add((byte)(msp & 0xFF));
		bf.add((byte) (msp));
		checksum ^= (msp & 0xFF);

		if (payload != null) {
			for (char c : payload) {
				bf.add((byte) (c & 0xFF));
				checksum ^= (c & 0xFF);
			}
		}
		bf.add(checksum);
		return (bf);
	}

	static void sendRequestMSP(List<Byte> msp) {
		byte[] arr = new byte[msp.size()];
		int i = 0;
		for (byte b : msp) {
			arr[i++] = b;
		}
		if (connected) {
			ctd.write(arr); // send the complete byte sequence in one go
		}
	}

	// ============================================================================

	byte[] inBuf = new byte[2048];
	byte[] readBuf = new byte[2048];
	int dataSize = 0, checksum = 0;
	byte cmdMSP = (byte) 0xFF;
	int p;

	int read32() {
		return (readBuf[p++] & 0xff) + ((readBuf[p++] & 0xff) << 8)
				+ ((readBuf[p++] & 0xff) << 16) + ((readBuf[p++] & 0xff) << 24);
	}

	int read16() {
		return (readBuf[p++] & 0xff) + ((readBuf[p++]) << 8);
	}

	int read8() {
		return readBuf[p++] & 0xff;
	}

	float readFloat() {
		final byte[] data = new byte[] { (byte) (readBuf[p++] & 0xff),
				(byte) (readBuf[p++] & 0xff), (byte) (readBuf[p++] & 0xff),
				(byte) (readBuf[p++] & 0xff) };
		final FloatBuffer fb = ByteBuffer.wrap(data).asFloatBuffer();
		final float[] dst = new float[fb.capacity()];
		fb.get(dst);
		return dst[0];
	}

	// ====================== tao lop , thread (tieu trinh) chay tu dong trong
	// qua trinh bluetooth DANG DUOC ket noi
	private class ConnectThread extends Thread {
		private final BluetoothSocket mmSocket;
		private final BluetoothDevice mmDevice;

		public ConnectThread(BluetoothDevice device) {
			// Use a temporary object that is later assigned to mmSocket,
			// because mmSocket is final
			BluetoothSocket tmp = null;
			mmDevice = device;

			// Get a BluetoothSocket to connect with the given BluetoothDevice
			try {
				// MY_UUID is the app's UUID string, also used by the server
				// code
				tmp = mmDevice.createRfcommSocketToServiceRecord(MY_UUID);
			} catch (IOException e) {
			}
			mmSocket = tmp;
		}

		@Override
		public void run() {
			// Cancel discovery because it will slow down the connection
			mBluetoothAdapter.cancelDiscovery();

			try {
				// Connect the device through the socket. This will block
				// until it succeeds or throws an exception
				mmSocket.connect();
			} catch (IOException connectException) {
				// Unable to connect; close the socket and get out
				try {
					mmSocket.close();
				} catch (IOException closeException) {
				}
				return;
			}

			// Do work to manage the connection (in a separate thread)
			// manageConnectedSocket(mmSocket);
			// connected();
			Message mes = mHandler.obtainMessage(CONNECTED, null);
			mHandler.sendMessage(mes);
			ctd = new ConnectedThread(mmSocket);
			ctd.start();
		}

		/** Will cancel an in-progress connection, and close the socket */
		@SuppressWarnings("unused")
		public void cancel() {
			try {
				mmSocket.close();
			} catch (IOException e) {
			}
		}
	}

	// =================== tao lop , viet code trong ham nay, thread (tieu
	// trinh) chay tu dong trong qua trinh bluetooth DA DUOC ket noi
	// static enum C_STATE {
	// IDLE, HEADER_START, HEADER_M, HEADER_ARROW, HEADER_SIZE, HEADER_CMD,
	// }

	static enum C_STATE {
		IDLE, HEADER_START, HEADER_M, HEADER_ARROW, HEADER_SIZE_L, HEADER_SIZE_H, HEADER_CMD
	}

	// static int cmdupdate = CMD_UPDATE_PRO;

	private class ConnectedThread extends Thread {
		private final BluetoothSocket mmSocket;
		private final InputStream mmInStream;
		private final OutputStream mmOutStream;

		public ConnectedThread(BluetoothSocket socket) {
			mmSocket = socket;
			InputStream tmpIn = null;
			OutputStream tmpOut = null;

			// Get the input and output streams, using temp objects because
			// member streams are final
			try {
				tmpIn = socket.getInputStream();
				tmpOut = socket.getOutputStream();
			} catch (IOException e) {
			}

			mmInStream = tmpIn;
			mmOutStream = tmpOut;
		}

		@Override
		public void run() {

			Message msg;

			int c = 0;
			int offset = 0;
			long lastTime = SystemClock.uptimeMillis();
			C_STATE c_state = C_STATE.IDLE;

			// ===============================================
			while (connected) {
				// ======================nhan du
				// lieu============================================
				try {

					while (mmInStream.available() > 0) {

						c = mmInStream.read();
						// if(c==-1) continue;

						// if(climode==true)// da cho phep che do command line
						// {
						// //byte datasize=(byte)mmInStream.read(inBuf);
						// //if(datasize>0)
						// //{
						// msg =
						// mHandler.obtainMessage(MESSAGE_CLIMODE,c,-1,inBuf);
						// mHandler.sendMessage(msg);
						// //}
						// continue;
						// }

						if (c_state == C_STATE.IDLE) {
							c_state = (c == '$') ? C_STATE.HEADER_START
									: C_STATE.IDLE;
							if (c_state == C_STATE.IDLE) {
								// //evaluateOtherData(c); // evaluate all other
								// incoming serial data
								// switch (c) {
								// case '#':
								// //cliProcess();
								// climode = true;
								// break;
								// case 'R':
								// //systemReset(true); // reboot to bootloader
								// break;
								// }//333
							}
						} else if (c_state == C_STATE.HEADER_START) {
							c_state = (c == 'M') ? C_STATE.HEADER_M
									: C_STATE.IDLE;
						} else if (c_state == C_STATE.HEADER_M) {
							c_state = (c == '>') ? C_STATE.HEADER_ARROW
									: C_STATE.IDLE;
						} else if (c_state == C_STATE.HEADER_ARROW) {

							c_state = C_STATE.HEADER_SIZE_L;
							dataSize = c & 0xFF;
							p = 0;
							offset = 0;
							checksum = 0;
							// indRX = 0;
							checksum ^= (c & 0xFF);

						} else if (c_state == C_STATE.HEADER_SIZE_L) {
							if (c > inBuf.length) { // now we are expecting the
													// payload size
								c_state = C_STATE.IDLE;
								continue;
							}
							dataSize = (c << 8) + dataSize;
							checksum ^= c;
							c_state = C_STATE.HEADER_SIZE_H;
						} else if (c_state == C_STATE.HEADER_SIZE_H) {
							cmdMSP = (byte) c;
							checksum ^= c;
							c_state = C_STATE.HEADER_CMD;
						} else if (c_state == C_STATE.HEADER_CMD
								&& offset < dataSize) {
							checksum ^= (c & 0xFF);
							inBuf[offset++] = (byte) (c & 0xFF);

						} else if (c_state == C_STATE.HEADER_CMD
								&& offset >= dataSize) {
							if ((checksum & 0xFF) == (c & 0xFF)) { // compare
																	// calculated
																	// and
																	// transferred
																	// checksum
								// we got a valid packet, evaluate it
								msg = mHandler.obtainMessage(MESSAGE_RECEIVED,
										cmdMSP, dataSize, inBuf);
								mHandler.sendMessage(msg); // goi msg di, de
															// phan tich va thuc
															// hien no
								// Toast.makeText(getApplicationContext(),("nhan du lieu......"),Toast.LENGTH_SHORT).show();
							}
							c_state = C_STATE.IDLE;
						} // end while
					}

				} catch (IOException e) {

					Toast.makeText(getApplicationContext(), ("loi......"),
							Toast.LENGTH_SHORT).show();
					break;
				}
				// 333
				// ==================== timer de request du
				// lieu==============================
				if (SystemClock.uptimeMillis() - lastTime > 100) {

					lastTime = SystemClock.uptimeMillis();
				}

			}// end while(true)
		}

		/* Call this from the main activity to send data to the remote device */
		public void write(byte[] bytes) {
			try {
				if (connected)
					mmOutStream.write(bytes);
			} catch (IOException e) {
			}
		}

		/* Call this from the main activity to shutdown the connection */
		public void cancel() {
			try {
				mmSocket.close();
			} catch (IOException e) {
			}
		}
	}

	// ---------- Xu ly thuc hien tac vu theo phuong thuc mhander
	// --------------------------------
	String readMessage = null;
	// viet code trong ham nay, thuc hien cac tac vu khi co yeu cau tu activity
	private final Handler mHandler = new Handler() {
		@Override
		public synchronized void handleMessage(Message msg) {
			int prolcd = 0, mprolcd = 0, kmprolcd = 0, fhutprolcd = 0, fxaprolcd = 0, fbtprolcd = 0, nchaiprolcd = 0, dm1prolcd = 0, dm2prolcd = 0, dm3prolcd = 0, dm4prolcd = 0, dm5prolcd = 0, dm6prolcd = 0, dm7prolcd = 0, dm8prolcd = 0, kxprolcd = 0;
			float fdm1prolcd, fdm2prolcd = 0, fdm3prolcd = 0, fdm4prolcd = 0, fdm5prolcd = 0, fdm6prolcd = 0, fdm7prolcd = 0, fdm8prolcd = 0, fkxprolcd = 0;
			readBuf = (byte[]) msg.obj;

			// construct a string from the valid bytes in the buffer
			int cmd = (int) (msg.arg1 & 0xFF);
			byte datasize = (byte) msg.arg2;

			switch (msg.what) {
			case MESSAGE_RECEIVED:
				switch (cmd) {

				default:
					break;
				}
			case CONNECTED:
				Toast.makeText(getApplicationContext(),
						"Connected to :" + "machine", Toast.LENGTH_SHORT)
						.show();
				connected = true;
				break;
			}
		};
	};

	// ------------------------ ham dung khoi dong bluetooth -----------------
	// --------------------------------------
	// //=================== khoi dong bluetooth tu dong chon mac dinh 1 board
	// bluetooth============================
	// private void initBluetooth(){
	// // Test if bluetooth is available on the device
	// mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
	// if (mBluetoothAdapter == null) {
	// // Device does not support Bluetooth
	// }
	//
	// if (!mBluetoothAdapter.isEnabled()) {
	// // Ask to start bluetooth if disabled : cho phep bluetooth neu bi tat
	// Intent enableBtIntent = new Intent(
	// BluetoothAdapter.ACTION_REQUEST_ENABLE);
	// startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
	// }
	//
	// int timOut =(int) SystemClock.uptimeMillis();
	// while (!mBluetoothAdapter.isEnabled() )
	// {
	// // if(SystemClock.uptimeMillis()-timOut >10000) break;// chinh thoi gian
	// de mo bluetooth
	// }; // cho den khi bluetooth cho phep hoac time out
	//
	// // firstSearch for all devices already paired
	// Set<BluetoothDevice> pairedDevices =
	// mBluetoothAdapter.getBondedDevices();
	// // If there are paired devices
	// if (pairedDevices.size() > 0) {
	// // Loop through paired devices
	// for (BluetoothDevice device : pairedDevices) {
	// //=========================================================================
	// //them vao de auto connect voi thiet bi cho truoc
	// //if(device.getAddress().equals("00:14:03:12:36:24")) //KIM
	// //if(device.getAddress().equals("00:14:03:12:34:22")) //MCR DEN
	// if(device.getAddress().equals("20:13:09:23:29:22")) //AKB1
	// {
	// ct = new ConnectThread(device);
	// ct.start();
	// // builder.show();
	// Toast.makeText(getApplicationContext(),
	// ("connecting......"),
	// Toast.LENGTH_SHORT).show();
	// }
	// }
	// }
	//
	// } // end initBluetooth
	// //=================== ket thuc bluetooth tu dong chon mac dinh 1 board
	// bluetooth================

	// =================== khoi dong bluetooth tu dong chon manual board
	// bluetooth=================
	private void initBluetooth() {
		adapter = new ArrayAdapter<String>(this,
				android.R.layout.simple_list_item_1, btResult);
		builder = new AlertDialog.Builder(this);
		builder.setTitle(getString(R.string.discover));

		builder.setAdapter(adapter, new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// The 'which' argument contains the index position
				// of the selected item
				deviceBt = btResult.get(which);
				Toast.makeText(getApplicationContext(),
						"Connection to :" + deviceBt, Toast.LENGTH_SHORT)
						.show();
				ct = new ConnectThread(btResultDevices.get(which));
				ct.start();
			}
		});
		builder.setCancelable(true);
		builder.create();

		// Devices discovery : tim thiet bi
		// Create a BroadcastReceiver for ACTION_FOUND
		mReceiver = new BroadcastReceiver() {
			@Override
			public void onReceive(Context context, Intent intent) {
				String action = intent.getAction();
				// When discovery finds a device
				if (BluetoothDevice.ACTION_ACL_DISCONNECTED.equals(action)) {
					// Get the BluetoothDevice object from the Intent
					BluetoothDevice device = intent
							.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
					Toast.makeText(getApplicationContext(),
							("disconected......"), Toast.LENGTH_SHORT).show();
					connected = false;
					ctd.cancel();

				}

				if (BluetoothDevice.ACTION_FOUND.equals(action)) {
					// Get the BluetoothDevice object from the Intent
					BluetoothDevice device = intent
							.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
					// Add the name and address to an array adapter to show in a
					// ListView
					// =========================================================================
					// First we check if the device already exists
					int index = -1;
					for (int i = 0; i < btResultDevices.size(); i++) {
						System.out.println();
						if (btResultDevices.get(i).getAddress()
								.equals(device.getAddress())) {
							index = i;
							break;
						}
					}
					if (index < 0) {
						btResultDevices.add(device);
						btResult.add(device.getName() + "\n"
								+ device.getAddress());
					} else {
						btResultDevices.remove(index);
						btResultDevices.add(index, device);
						btResult.remove(index);
						btResult.add(index,
								device.getName() + "\n" + device.getAddress());
					}
					// -------------------------------------------------------------------------

					adapter.notifyDataSetChanged();
				}
			}
		};

		// Register the BroadcastReceiver : dang ki cho BroadcastReceiver
		f1 = new IntentFilter(BluetoothDevice.ACTION_ACL_DISCONNECT_REQUESTED);
		f2 = new IntentFilter(BluetoothDevice.ACTION_ACL_DISCONNECTED);
		this.registerReceiver(mReceiver, f1);
		this.registerReceiver(mReceiver, f2);

		// Register the BroadcastReceiver : dang ki cho BroadcastReceiver
		filter = new IntentFilter(BluetoothDevice.ACTION_FOUND);
		registerReceiver(mReceiver, filter); // Don't forget to unregister
		// during onDestroy
		// Test if bluetooth is available on the device
		mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
		if (mBluetoothAdapter == null) {
			// Device does not support Bluetooth
		}

		if (!mBluetoothAdapter.isEnabled()) {
			// Ask to start bluetooth if disabled : cho phep bluetooth neu bi
			// tat
			Intent enableBtIntent = new Intent(
					BluetoothAdapter.ACTION_REQUEST_ENABLE);
			startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
		}

		int timOut = (int) SystemClock.uptimeMillis();
		while (!mBluetoothAdapter.isEnabled()) {
			if (SystemClock.uptimeMillis() - timOut > 10000)
				break;// chinh thoi gian de mo bluetooth
		}
		;
		if (connected) {
			// ctd.cancel();
			// connected = false;

		} else {
			if (mBluetoothAdapter.startDiscovery()) {
				builder.show();
				Toast.makeText(getApplicationContext(),
						getString(R.string.discovery_begin), Toast.LENGTH_SHORT)
						.show();
			}
		}

		// firstSearch for all devices already paired
		Set<BluetoothDevice> pairedDevices = mBluetoothAdapter
				.getBondedDevices();
		// If there are paired devices
		if (pairedDevices.size() > 0) {
			// Loop through paired devices
			for (BluetoothDevice device : pairedDevices) {
				// Add the name and address to an array adapter to show in a
				// ListView
				// addDevice(device);
				// =========================================================================
				// First we check if the device already exists
				int index = -1;
				for (int i = 0; i < btResultDevices.size(); i++) {
					System.out.println();
					if (btResultDevices.get(i).getAddress()
							.equals(device.getAddress())) {
						index = i;
						break;
					}
				}
				if (index < 0) {
					btResultDevices.add(device);
					btResult.add(device.getName() + "\n" + device.getAddress());
				} else {
					btResultDevices.remove(index);
					btResultDevices.add(index, device);
					btResult.remove(index);
					btResult.add(index,
							device.getName() + "\n" + device.getAddress());
				}
				// -------------------------------------------------------------------------
			}
		}

	} // end initBluetooth
		// tat bluetooth

	public void quitApp() {
		// Ask to switch off Bluetooth
		AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
		builder.setMessage(R.string.quitBt)
				.setPositiveButton(R.string.ok,
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog, int id) {
								mBluetoothAdapter.disable();
								finish();
								System.exit(0);
							}
						})
				.setNegativeButton(R.string.cancel,
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog, int id) {
								// User cancelled the dialog
								finish();
								System.exit(0);
							}
						}).setCancelable(true);
		// Create the AlertDialog object and return it
		builder.create().show();
	}

	// ================================== KET THUC CAC HAM CAN THIET CHO
	// BLUETOOTH ==========================//

	// tat ung dung khi nhan nut back
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if ((keyCode == KeyEvent.KEYCODE_BACK)) {
			quitApp();
		}
		return super.onKeyDown(keyCode, event);
	}

	// tat tam thoi cac tieu trinh khi ung dung bi dung tam thoi
	@Override
	public void onStop() {
		// if (mReceiver != null)
		// unregisterReceiver(mReceiver);
		// if (ctd != null && ctd.isAlive())
		// ctd.cancel();
		super.onStop();
	}

	// tat ung dung khi tat ung dung
	@Override
	public void onDestroy() {
		quitApp();
		super.onDestroy();

	}

	// ==========Button Declaration==========================//
	static Button buttonA, buttonB, buttonC, buttonD;
	static Button btnToi, btnLui, btnTrai, btnPhai,btnStop;
	// =============================================
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		//setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
		// =============Remove thanh Title=================================
		//requestWindowFeature(Window.FEATURE_NO_TITLE);
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
				WindowManager.LayoutParams.FLAG_FULLSCREEN);
		setContentView(R.layout.activity_main);
		// ========= khoi dong bluetooth ==================//
		initBluetooth();
		btnToi = (Button) findViewById(R.id.btnToi);
		btnLui = (Button) findViewById(R.id.btnLui);
		btnTrai = (Button) findViewById(R.id.btnTrai);
		btnPhai = (Button) findViewById(R.id.btnPhai);
		//btnStop = (Button) findViewById(R.id.btnStop);


		btnToi.setOnTouchListener(new OnTouchListener() {
        	public boolean onTouch(View v, MotionEvent event){
        		byte[] arr = new byte[1];
                switch(event.getAction())
                {
                case MotionEvent.ACTION_DOWN:
        			arr[0] = 'F';
    				if (connected) {
    					btnToi.setTextColor(Color.RED);
    					ctd.write(arr); // send the complete byte sequence in one go
    				}
             	
                	break;
                case MotionEvent.ACTION_UP: 
    				arr[0] = 'S';
    				if (connected) {
    					btnToi.setTextColor(Color.BLACK);
    					ctd.write(arr); // send the complete byte sequence in one go
    				}
                	
                	break;
                }
                return false;
            }
			});
		btnLui.setOnTouchListener(new OnTouchListener() {
        	public boolean onTouch(View v, MotionEvent event){
        		byte[] arr = new byte[1];
                switch(event.getAction())
                {
                case MotionEvent.ACTION_DOWN:
        			arr[0] = 'B';
    				if (connected) {
    					btnLui.setTextColor(Color.RED);
    					ctd.write(arr); // send the complete byte sequence in one go
    				}
             	
                	break;
                case MotionEvent.ACTION_UP: 
    				arr[0] = 'S';
    				if (connected) {
    					btnLui.setTextColor(Color.BLACK);
    					ctd.write(arr); // send the complete byte sequence in one go
    				}
                	
                	break;
                }
                return false;
            }
			});
		btnTrai.setOnTouchListener(new OnTouchListener() {
        	public boolean onTouch(View v, MotionEvent event){
        		byte[] arr = new byte[1];
                switch(event.getAction())
                {
                case MotionEvent.ACTION_DOWN:
        			arr[0] = 'L';
    				if (connected) {
    					btnTrai.setTextColor(Color.RED);
    					ctd.write(arr); // send the complete byte sequence in one go
    				}
             	
                	break;
                case MotionEvent.ACTION_UP: 
    				arr[0] = 'S';
    				if (connected) {
    					btnTrai.setTextColor(Color.BLACK);
    					ctd.write(arr); // send the complete byte sequence in one go
    				}
                	
                	break;
                }
                return false;
            }
			});
		btnPhai.setOnTouchListener(new OnTouchListener() {
        	public boolean onTouch(View v, MotionEvent event){
        		byte[] arr = new byte[1];
                switch(event.getAction())
                {
                case MotionEvent.ACTION_DOWN:
        			arr[0] = 'R';
    				if (connected) {
    					btnPhai.setTextColor(Color.RED);
    					ctd.write(arr); // send the complete byte sequence in one go
    				}
             	
                	break;
                case MotionEvent.ACTION_UP: 
    				arr[0] = 'S';
    				if (connected) {
    					btnPhai.setTextColor(Color.BLACK);
    					ctd.write(arr); // send the complete byte sequence in one go
    				}
                	
                	break;
                }
                return false;
            }
			});
//		btnStop.setOnClickListener(new View.OnClickListener() {
//			public void onClick(View v) {
//				// Perform action on click
//				byte[] arr = new byte[1];
//				arr[0] = 'S';
//				if (connected) {
//					ctd.write(arr); // send the complete byte sequence in one go
//				}
//
//			}
//		});


	}

}