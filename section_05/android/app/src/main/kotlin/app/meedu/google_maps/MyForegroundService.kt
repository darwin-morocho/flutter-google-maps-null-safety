package app.meedu.google_maps

import android.app.*
import android.content.Intent
import android.os.Binder
import android.os.Build
import android.os.IBinder

class MyForegroundService : Service() {
    override fun onBind(intent: Intent?): IBinder {
        return Binder()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        val pendingIntent: PendingIntent =
            Intent(this, MainActivity::class.java).let { notificationIntent ->
                PendingIntent.getActivity(this, 0, notificationIntent, 0)
            }

        val builder = Notification.Builder(this)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            // Create the NotificationChannel
            val name = "background location"
            val descriptionText = "show a notification as a foreground service"
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val mChannel = NotificationChannel(MainActivity.CHANNEL_NAME, name, importance)
            mChannel.description = descriptionText
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(mChannel)

            builder.setChannelId(MainActivity.CHANNEL_NAME)


        }
        val notification: Notification = builder.setContentTitle("meedu.app")
            .setContentText("Tracking location")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .build()

        startForeground(1000, notification)
        return START_NOT_STICKY
    }
}