package com.example.test_wifi_app

import android.Manifest
import android.content.pm.PackageManager
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Intent
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.IntentFilter
import android.os.Bundle
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
// полный функцианальны код

class MainActivity : FlutterActivity() {
    private val CHANNEL = "bluetooth_classic_channel"
    private val PERMISSION_REQUEST_CODE = 1
    private val REQUEST_ENABLE_BT = 1001


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getPermission" -> {
                    requestAllPermissions(result)
                }
                "scanDevices" -> {
                    scanBluetoothDevices(result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun requestAllPermissions(result: MethodChannel.Result) {
        // Создаем списки разрешений, которые нужно запросить
        val permissionsToRequest = mutableListOf<String>()

        // Проверяем версию Android
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Android 12 или более поздняя версия

            // Добавляем новые разрешения Bluetooth для Android 12+
            permissionsToRequest.add(Manifest.permission.BLUETOOTH_SCAN)
            permissionsToRequest.add(Manifest.permission.BLUETOOTH_CONNECT)
        } else {
            // Android 11 или более ранняя версия

            // Добавляем разрешения на местоположение для работы с Bluetooth
            permissionsToRequest.add(Manifest.permission.ACCESS_COARSE_LOCATION)
            permissionsToRequest.add(Manifest.permission.ACCESS_FINE_LOCATION)
        }

        // Общие разрешения Bluetooth для всех версий Android
        permissionsToRequest.add(Manifest.permission.BLUETOOTH)
        permissionsToRequest.add(Manifest.permission.BLUETOOTH_ADMIN)

        // Проверяем, какие разрешения еще не были предоставлены
        val permissionsStillNeeded = permissionsToRequest.filter { permission ->
            ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED
        }

        if (permissionsStillNeeded.isNotEmpty()) {
            // Запрос всех необходимых разрешений
            ActivityCompat.requestPermissions(this, permissionsStillNeeded.toTypedArray(), PERMISSION_REQUEST_CODE)
        } else {
            // Все необходимые разрешения уже предоставлены
            result.success(true)
        }
    }


    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == PERMISSION_REQUEST_CODE) {
            // Проверьте результаты
            val allPermissionsGranted = grantResults.all { it == PackageManager.PERMISSION_GRANTED }

            // Убедитесь, что переменная flutterEngine и ее составляющие не равны null
            flutterEngine?.dartExecutor?.binaryMessenger?.let { binaryMessenger ->
                MethodChannel(binaryMessenger, CHANNEL)
                    .invokeMethod("permissionResult", allPermissionsGranted)
            } ?: run {
                // Обработка случая, если `flutterEngine`, `dartExecutor` или `binaryMessenger` равны null.
                // Например, можно написать сообщение об ошибке или выполнить другое действие.
                println("Ошибка: Не удалось получить binaryMessenger для отправки результатов.")
            }
        }
    }

    private fun scanBluetoothDevices(result: MethodChannel.Result) {
        val bluetoothManager: BluetoothManager = getSystemService(BluetoothManager::class.java)
        val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter

        if (bluetoothAdapter == null) {
            // Устройство не поддерживает Bluetooth
            result.error("Bluetooth not supported", "This device doesn't support Bluetooth.", null)
            return
        }

        enebleBluetooth(bluetoothAdapter)

        GlobalScope.launch {
            try {
                val devices: MutableList<Pair<String, String>> = mutableListOf()

                // 2.1 - ищем устройства Query paired devices
                val pairedDevices = findQueryPairedDevices(bluetoothAdapter)
                devices.addAll(pairedDevices)

                // 2.2 - ищем устройства Discover devices
                val discoveredDevices = findDiscoverDevices(bluetoothAdapter, applicationContext)
                devices.addAll(discoveredDevices)

                // Отправка найденных устройств в результате
                result.success(devices.map { device ->
                    mapOf(
                        "name" to device.first,
                        "address" to device.second
                    )
                })
            } catch (e: Exception) {
                // Обработка ошибок
                result.error("Bluetooth scanning failed", e.message, null)
            }
        }
    }


    private fun enebleBluetooth(bluetoothAdapter: BluetoothAdapter){
        if (bluetoothAdapter?.isEnabled == false) {
            val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
            startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT)
        }
    }

    private fun findQueryPairedDevices(bluetoothAdapter: BluetoothAdapter): List<Pair<String, String>> {
        // Создаем пустой список для хранения пар (имя устройства, MAC-адрес)
        val devicesList = mutableListOf<Pair<String, String>>()
        
        // Получаем список сопряженных устройств
        val pairedDevices: Set<BluetoothDevice>? = bluetoothAdapter.bondedDevices
        
        // Проверяем, есть ли сопряженные устройства
        if (pairedDevices.isNullOrEmpty()) {
            println("No paired devices found")
        } else {
            // Проходим по каждому сопряженному устройству
            pairedDevices.forEach { device ->
                // Получаем имя устройства
                val deviceName = device.name
                // Получаем MAC-адрес устройства
                val deviceHardwareAddress = device.address
                // Добавляем пару (имя устройства, MAC-адрес) в список
                devicesList.add(Pair(deviceName, deviceHardwareAddress))
            }
        }
        // Возвращаем список пар (имя устройства, MAC-адрес)
        return devicesList
    }

    suspend fun findDiscoverDevices(bluetoothAdapter: BluetoothAdapter, context: Context): List<Pair<String, String>> {
        val discoveredDevicesList = mutableListOf<Pair<String, String>>()

        // Создаем канал для сигнализации об окончании процесса сканирования
        val discoveryFinished = CompletableDeferred<Unit>()

        // Создаем приемник для обработки найденных устройств и завершения сканирования
        val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                when (intent.action) {
                    BluetoothDevice.ACTION_FOUND -> {
                        val device = intent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE)
                        device?.let {
                            val deviceName = it.name ?: "Unknown"
                            val deviceHardwareAddress = it.address
                            discoveredDevicesList.add(Pair(deviceName, deviceHardwareAddress))
                        }
                    }
                    BluetoothAdapter.ACTION_DISCOVERY_FINISHED -> {
                        println("Scanning finished")
                        context.unregisterReceiver(this)
                        discoveryFinished.complete(Unit)
                    }
                }
            }
        }

        // Регистрируем приемник для обработки намерений о найденных устройствах и завершении сканирования
        val filter = IntentFilter().apply {
            addAction(BluetoothDevice.ACTION_FOUND)
            addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED)
        }
        context.registerReceiver(receiver, filter)

        bluetoothAdapter.startDiscovery()

        // Ждем завершения процесса сканирования
        discoveryFinished.await()

        // Останавливаем процесс обнаружения
        bluetoothAdapter.cancelDiscovery()

        return discoveredDevicesList
    }


}

