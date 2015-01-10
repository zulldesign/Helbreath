/* Copyright (c) 2009 Jordan Kasper
 * Licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * Copyright notice and license must remain intact for legal use
 * 
 * Fore usage documentation and examples, visit:
 *         http://jkdesign.org/captcha/
 */
;(function($){$.fn.simpleCaptcha=function(o){var n=this;if(n.length<1){return n;}
o=(o)?o:{};o=auditOptions($.extend({},$.fn.simpleCaptcha.defaults,o));var inputId="simpleCaptcha_"+($.fn.simpleCaptcha.uid++);n.addClass('simpleCaptcha').html('').append("<div class='"+o.introClass+"'>"+o.introText+"</div>"+"<div class='"+o.imageBoxClass+"'></div>"+"<input class='simpleCaptchaInput' id='"+inputId+"' name='"+o.inputName+"' type='hidden' value='' />");$.ajax({url:o.scriptPath,data:{numImages:o.numImages},method:'post',dataType:'json',success:function(data,status){if(typeof data.error=='string'){handleError(n,data.error);return;}else{n.find('.'+o.textClass).html(data.text);var imgBox=n.find('.'+o.imageBoxClass);$.each(data.images,function(){imgBox.append("<img class='"+o.imageClass+"' src='"+this.file+"' alt='' title='"+this.hash+"' />");});imgBox.find('img.'+o.imageClass).click(function(e){n.find('img.'+o.imageClass).removeClass('simpleCaptchaSelected');var hash=$(this).addClass('simpleCaptchaSelected').attr('title');$('#'+inputId).val(hash);n.trigger('select.simpleCaptcha',[hash]);return false;}).keyup(function(e){if(e.keyCode==13||e.which==13){$(this).click();}});n.trigger('loaded.simpleCaptcha',[data]);}},error:function(xhr,status){handleError(n,'There was a serious problem: '+xhr.status);}});return n;};var handleError=function(n,msg){n.trigger('error.simpleCaptcha',[msg]);}
var auditOptions=function(o){if(typeof o.numImages!='number'||o.numImages<1){o.numImages=$.fn.simpleCaptcha.defaults.numImages;}
if(typeof o.introText!='string'||o.introText.length<1){o.introText=$.fn.simpleCaptcha.defaults.introText;}
if(typeof o.inputName!='string'){o.inputName=$.fn.simpleCaptcha.defaults.inputName;}
if(typeof o.scriptPath!='string'){o.scriptPath=$.fn.simpleCaptcha.defaults.scriptPath;}
if(typeof o.introClass!='string'){o.introClass=$.fn.simpleCaptcha.defaults.introClass;}
if(typeof o.textClass!='string'){o.textClass=$.fn.simpleCaptcha.defaults.textClass;}
if(typeof o.imageBoxClass!='string'){o.imageBoxClass=$.fn.simpleCaptcha.defaults.imageBoxClass;}
if(typeof o.imageClass!='string'){o.imageClass=$.fn.simpleCaptcha.defaults.imageClass;}
return o;}
$.fn.simpleCaptcha.uid=0;$.fn.simpleCaptcha.defaults={numImages:5,introText:"<p>To make sure you are a human, we need you to click on the <span class='captchaText'></span>.</p>",inputName:'captchaSelection',scriptPath:'simpleCaptcha.php',introClass:'captchaIntro',textClass:'captchaText',imageBoxClass:'captchaImages',imageClass:'captchaImage'};})(jQuery);