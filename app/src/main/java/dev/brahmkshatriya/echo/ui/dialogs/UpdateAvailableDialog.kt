package dev.brahmkshatriya.echo.ui.dialogs

import android.animation.ObjectAnimator
import android.animation.ValueAnimator
import android.app.Dialog
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.animation.AccelerateDecelerateInterpolator
import android.view.animation.OvershootInterpolator
import android.widget.ImageView
import android.widget.TextView
import com.google.android.material.button.MaterialButton
import dev.brahmkshatriya.echo.R

class UpdateAvailableDialog(
    context: Context,
    private val version: String,
    private val onInstallClick: () -> Unit,
    private val onCancelClick: () -> Unit
) : Dialog(context, R.style.CustomDialogTheme) {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        val view = LayoutInflater.from(context).inflate(R.layout.dialog_update_available, null)
        setContentView(view)
        
        // Rendre le dialogue transparent
        window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        
        setupViews(view)
        startAnimations(view)
    }
    
    private fun setupViews(view: View) {
        val versionText = view.findViewById<TextView>(R.id.version_text)
        val btnInstall = view.findViewById<MaterialButton>(R.id.btn_install)
        val btnCancel = view.findViewById<MaterialButton>(R.id.btn_cancel)
        
        versionText.text = version
        
        btnInstall.setOnClickListener {
            startExitAnimation(view) {
                onInstallClick()
                dismiss()
            }
        }
        
        btnCancel.setOnClickListener {
            startExitAnimation(view) {
                onCancelClick()
                dismiss()
            }
        }
        
        // Empêcher la fermeture accidentelle
        setCancelable(false)
    }
    
    private fun startAnimations(view: View) {
        val updateIcon = view.findViewById<ImageView>(R.id.update_icon)
        
        // Animation d'entrée du dialogue avec scale et alpha
        view.alpha = 0f
        view.scaleX = 0.7f
        view.scaleY = 0.7f
        
        view.animate()
            .alpha(1f)
            .scaleX(1f)
            .scaleY(1f)
            .setDuration(400)
            .setInterpolator(OvershootInterpolator(1.2f))
            .start()
        
        // Animation de rotation continue pour l'icône
        val rotationAnimator = ObjectAnimator.ofFloat(updateIcon, "rotation", 0f, 360f)
        rotationAnimator.duration = 3000
        rotationAnimator.repeatCount = ValueAnimator.INFINITE
        rotationAnimator.interpolator = AccelerateDecelerateInterpolator()
        rotationAnimator.start()
        
        // Animation de pulse pour l'icône
        val scaleAnimator = ObjectAnimator.ofFloat(updateIcon, "scaleX", 1f, 1.1f, 1f)
        val scaleAnimatorY = ObjectAnimator.ofFloat(updateIcon, "scaleY", 1f, 1.1f, 1f)
        scaleAnimator.duration = 2000
        scaleAnimatorY.duration = 2000
        scaleAnimator.repeatCount = ValueAnimator.INFINITE
        scaleAnimatorY.repeatCount = ValueAnimator.INFINITE
        scaleAnimator.start()
        scaleAnimatorY.start()
    }
    
    private fun startExitAnimation(view: View, onComplete: () -> Unit) {
        view.animate()
            .alpha(0f)
            .scaleX(0.8f)
            .scaleY(0.8f)
            .setDuration(200)
            .setInterpolator(AccelerateDecelerateInterpolator())
            .withEndAction(onComplete)
            .start()
    }
}
