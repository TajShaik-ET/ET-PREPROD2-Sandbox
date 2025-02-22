({   
    doInit : function(component, event, helper) {
       
         helper.getFileDetails(component, event, helper);
      
        var imgUrl = $A.get('$Resource.CICO_NoImage');       
        component.set('v.imgUrl',imgUrl);
        
        var device = $A.get("$Browser.formFactor");
        
        
       
        console.log('--device--'+device);//mobile = 300, tab = 300, desktop = 500
              
    },
    
	doInitCanvas : function(component, event, helper) {
        //Canvas for car diagram start 
        try{  
            
           //Range slider logic starts
            let vol = component.find("vol").getElement();
            let rangeVal = component.find("rangeVal").getElement();
            
           
            vol.addEventListener("input", function (e){
               
               component.set("v.sliderVal",vol.value);
              vol.style = generateBackground(vol.value);
             // console.log(generateBackground(vol.value));
               
            },false);
            
            function generateBackground(val){
                let color1 = '';
                let color2 = '';
                let color3 = '';
                if (val === 0) {
                    return
                }
                if(val <= 70){
                     color1 = '#f03e3e';
                     color2 = '#f03e3e';
                     color3 = '#30b32d';
                }
                if(val > 70){
                     color1 = '#30b32d';
                     color2 = '#30b32d';
                     color3 = '#30b32d';
                }
                
                let percentage =  (val - 0) / (100 - 0) * 100
               return 'background: linear-gradient(to right,'+color1+','+color2+' ' + percentage + '%, #d3edff ' + percentage + '%, #dee1e2 100%)'
                
            }
             //Range slider logic ends
            //Canvas         
 
            var canvas, ctx, flag = false,
                prevX = 0,
                currX = 0,
                prevY = 0,
                currY = 0,
                dot_flag = false;
            
            var x = "red",
                y = 2,
                w,h;
            canvas= component.find("canvasDia").getElement();
           
            var ratio = Math.max(window.devicePixelRatio || 1, 1);
            w = canvas.width*ratio;
            h = canvas.height*ratio;
            ctx = canvas.getContext("2d");
            var img = component.find('customImg').getElement(); 
           
            img.onload = function() {
                ctx.drawImage(img,0,0,img.width,img.height);
            }
           
            //console.log('ctx:='+ctx);
            
            canvas.addEventListener("mousemove", function (e) {
                findxy('move', e)
            }, false);
            canvas.addEventListener("mousedown", function (e) {
                findxy('down', e)
            }, false);
            canvas.addEventListener("mouseup", function (e) {
                findxy('up', e)
                setLocalStoreage();                  
            }, false);
            canvas.addEventListener("mouseout", function (e) {
                findxy('out', e)
            }, false);
            // Set up touch events for mobile, etc
            canvas.addEventListener("touchstart", function (e) {
                var touch = e.touches[0];
                //console.log('touch start:='+touch);
                var mouseEvent = new MouseEvent("mousedown", {
                    clientX: touch.clientX,
                    clientY: touch.clientY
                });
                canvas.dispatchEvent(mouseEvent);
                e.preventDefault();
            }, false);
            canvas.addEventListener("touchend", function (e) {
                var mouseEvent = new MouseEvent("mouseup", {});
                canvas.dispatchEvent(mouseEvent);
            }, false);
            canvas.addEventListener("touchmove", function (e) {
                var touch = e.touches[0];
                var mouseEvent = new MouseEvent("mousemove", {
                    clientX: touch.clientX,
                    clientY: touch.clientY
                });
                canvas.dispatchEvent(mouseEvent);
                e.preventDefault();
                
            }, false);
            
            // Get the position of a touch relative to the canvas
            function getTouchPos(canvasDom, touchEvent) {
                var rect = canvasDom.getBoundingClientRect();
                return {
                    x: touchEvent.touches[0].clientX - rect.left,
                    y: touchEvent.touches[0].clientY - rect.top
                };
            }
            
            function findxy(res, e){
                const rect = canvas.getBoundingClientRect();
                if (res == 'down') {
                    prevX = currX;
                    prevY = currY;
                    currX = e.clientX - rect.left ;
                    currY = e.clientY -  rect.top;
                    
                    flag = true;
                    dot_flag = true;
                    if (dot_flag) {
                        ctx.beginPath();
                        ctx.fillStyle = x;
                        ctx.fillRect(currX, currY, 2, 2);
                        ctx.closePath();
                        dot_flag = false;
                    }
                }
                if (res == 'up' || res == "out") {
                    flag = false;
                }
                if (res == 'move') {
                    if (flag) {
                        prevX = currX;
                        prevY = currY;
                        currX = e.clientX -  rect.left;
                        currY = e.clientY - rect.top;
                        draw(component,ctx);
                    }
                }
            }
            function draw() {
                
                ctx.beginPath();
                ctx.moveTo(prevX, prevY);
                ctx.lineTo(currX, currY);
                ctx.strokeStyle = x;
                ctx.lineWidth = y;
                ctx.stroke();
                
                ctx.closePath();
            }
            
        } catch(e){
            console.log("-Diagram Canvas Error--"+e.message);
           
        }
        //Canvas for car diagram End--  
       
       
        //Canvas for Signature - Start
        try{
        var s_canvas, s_ctx, s_flag = false,
            s_prevX = 0,
            s_currX = 0,
            s_prevY = 0,
            s_currY = 0,
            s_dot_flag = false;
        
        var s_x = "blue",
            s_y = 2,
            s_w,s_h;
        s_canvas=component.find('canvasSign').getElement();
       
        var s_ratio = Math.max(window.devicePixelRatio || 1, 1);
        s_w = s_canvas.width*s_ratio;
        s_h = s_canvas.height*s_ratio;
        s_ctx = s_canvas.getContext("2d");
                            
        s_canvas.addEventListener("mousemove", function (e) {
            s_findxy('move', e)
        }, false);
        s_canvas.addEventListener("mousedown", function (e) {
            s_findxy('down', e)
        }, false);
        s_canvas.addEventListener("mouseup", function (e) {
            s_findxy('up', e)
        }, false);
        s_canvas.addEventListener("mouseout", function (e) {
            s_findxy('out', e)
        }, false);
        // Set up touch events for mobile, etc
        s_canvas.addEventListener("touchstart", function (e) {
            var s_touch = e.touches[0];
           // console.log('touch start:='+s_touch);
            var s_mouseEvent = new MouseEvent("mousedown", {
                clientX: s_touch.clientX,
                clientY: s_touch.clientY
            });
            s_canvas.dispatchEvent(s_mouseEvent);
            e.preventDefault();
        }, false);
        s_canvas.addEventListener("touchend", function (e) {
            var s_mouseEvent = new MouseEvent("mouseup", {});
            s_canvas.dispatchEvent(s_mouseEvent);
        }, false);
        s_canvas.addEventListener("touchmove", function (e) {
            var touch = e.touches[0];
            var s_mouseEvent = new MouseEvent("mousemove", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            s_canvas.dispatchEvent(s_mouseEvent);
            e.preventDefault();
            
        }, false);
        
        // Get the position of a touch relative to the canvas
        function s_getTouchPos(canvasDom, touchEvent) {
            var rect = canvasDom.getBoundingClientRect();
            return {
                s_x: touchEvent.touches[0].clientX - rect.left,
                s_y: touchEvent.touches[0].clientY - rect.top
            };
        }
        
        function s_findxy(res, e){
            const rect = s_canvas.getBoundingClientRect();
            if (res == 'down') {
                s_prevX = s_currX;
                s_prevY = s_currY;
                s_currX = e.clientX - rect.left ;
                s_currY = e.clientY -  rect.top;
                
                s_flag = true;
                s_dot_flag = true;
                if (s_dot_flag) {
                    s_ctx.beginPath();
                    s_ctx.fillStyle = s_x;
                    s_ctx.fillRect(s_currX, s_currY, 2, 2);
                    s_ctx.closePath();
                    s_dot_flag = false;
                }
            }
            if (res == 'up' || res == "out") {
                s_flag = false;
            }
            if (res == 'move') {
                if (s_flag) {
                    s_prevX = s_currX;
                    s_prevY = s_currY;
                    s_currX = e.clientX -  rect.left;
                    s_currY = e.clientY - rect.top;
                    s_draw(component,ctx);
                }
            }
        }
        function s_draw() {
            
            s_ctx.beginPath();
            s_ctx.moveTo(s_prevX, s_prevY);
            s_ctx.lineTo(s_currX, s_currY);
            s_ctx.strokeStyle = s_x;
            s_ctx.lineWidth = s_y;
            s_ctx.stroke();
            
            s_ctx.closePath();
        }
        }catch(e){
            
            console.log('--Sign--Erro'+e.message);
        }
        
        //Canvas for Signature - End
       
        /** Signature 2 canvas start here **/
        try{
            var s2_canvas, s2_ctx, s2_flag = false,
                s2_prevX = 0,
                s2_currX = 0,
                s2_prevY = 0,
                s2_currY = 0,
                s2_dot_flag = false;
            
            var s2_x = "blue",
                s2_y = 2,
                s2_w,s2_h;
            s2_canvas=component.find('canvasSign2').getElement();
            
            var s2_ratio = Math.max(window.devicePixelRatio || 1, 1);
            s2_w = s2_canvas.width*s2_ratio;
            s2_h = s2_canvas.height*s2_ratio;
            s2_ctx = s2_canvas.getContext("2d");
            
            s2_canvas.addEventListener("mousemove", function (e) {
                s2_findxy('move', e)
            }, false);
            s2_canvas.addEventListener("mousedown", function (e) {
                s2_findxy('down', e)
            }, false);
            s2_canvas.addEventListener("mouseup", function (e) {
                s2_findxy('up', e)
            }, false);
            s2_canvas.addEventListener("mouseout", function (e) {
                s2_findxy('out', e)
            }, false);
            // Set up touch events for mobile, etc
            s2_canvas.addEventListener("touchstart", function (e) {
                var s2_touch = e.touches[0];
                // console.log('touch start:='+s2_touch);
                var s2_mouseEvent = new MouseEvent("mousedown", {
                    clientX: s2_touch.clientX,
                    clientY: s2_touch.clientY
                });
                s2_canvas.dispatchEvent(s2_mouseEvent);
                e.preventDefault();
            }, false);
            s2_canvas.addEventListener("touchend", function (e) {
                var s2_mouseEvent = new MouseEvent("mouseup", {});
                s2_canvas.dispatchEvent(s2_mouseEvent);
            }, false);
            s2_canvas.addEventListener("touchmove", function (e) {
                var touch = e.touches[0];
                var s2_mouseEvent = new MouseEvent("mousemove", {
                    clientX: touch.clientX,
                    clientY: touch.clientY
                });
                s2_canvas.dispatchEvent(s2_mouseEvent);
                e.preventDefault();
                
            }, false);
            
            // Get the position of a touch relative to the canvas
            function s2_getTouchPos(canvasDom, touchEvent) {
                var rect = canvasDom.getBoundingClientRect();
                return {
                    s2_x: touchEvent.touches[0].clientX - rect.left,
                    s2_y: touchEvent.touches[0].clientY - rect.top
                };
            }
            
            function s2_findxy(res, e){
                const rect = s2_canvas.getBoundingClientRect();
                if (res == 'down') {
                    s2_prevX = s2_currX;
                    s2_prevY = s2_currY;
                    s2_currX = e.clientX - rect.left ;
                    s2_currY = e.clientY -  rect.top;
                    
                    s2_flag = true;
                    s2_dot_flag = true;
                    if (s2_dot_flag) {
                        s2_ctx.beginPath();
                        s2_ctx.fillStyle = s2_x;
                        s2_ctx.fillRect(s2_currX, s2_currY, 2, 2);
                        s2_ctx.closePath();
                        s2_dot_flag = false;
                    }
                }
                if (res == 'up' || res == "out") {
                    s2_flag = false;
                }
                if (res == 'move') {
                    if (s2_flag) {
                        s2_prevX = s2_currX;
                        s2_prevY = s2_currY;
                        s2_currX = e.clientX -  rect.left;
                        s2_currY = e.clientY - rect.top;
                        s2_draw(component,ctx);
                    }
                }
            }
            function s2_draw() {
                
                s2_ctx.beginPath();
                s2_ctx.moveTo(s2_prevX, s2_prevY);
                s2_ctx.lineTo(s2_currX, s2_currY);
                s2_ctx.strokeStyle = s2_x;
                s2_ctx.lineWidth = s2_y;
                s2_ctx.stroke();
                
                s2_ctx.closePath();
            }
        }catch(e){
            
            console.log('--Sign2--Erro'+e.message);
        }
        
        /** Signature 2 canvas ends here **/
        
          /** Signature 3 canvas start here **/
        try{
        var s3_canvas, s3_ctx, s3_flag = false,
            s3_prevX = 0,
            s3_currX = 0,
            s3_prevY = 0,
            s3_currY = 0,
            s3_dot_flag = false;
        
        var s3_x = "blue",
            s3_y = 2,
            s3_w,s3_h;
        s3_canvas=component.find('canvasSign3').getElement();
       
        var s3_ratio = Math.max(window.devicePixelRatio || 1, 1);
        s3_w = s3_canvas.width*s3_ratio;
        s3_h = s3_canvas.height*s3_ratio;
        s3_ctx = s3_canvas.getContext("2d");
                            
        s3_canvas.addEventListener("mousemove", function (e) {
            s3_findxy('move', e)
        }, false);
        s3_canvas.addEventListener("mousedown", function (e) {
            s3_findxy('down', e)
        }, false);
        s3_canvas.addEventListener("mouseup", function (e) {
            s3_findxy('up', e)
        }, false);
        s3_canvas.addEventListener("mouseout", function (e) {
            s3_findxy('out', e)
        }, false);
        // Set up touch events for mobile, etc
        s3_canvas.addEventListener("touchstart", function (e) {
            var s3_touch = e.touches[0];
           // console.log('touch start:='+s3_touch);
            var s3_mouseEvent = new MouseEvent("mousedown", {
                clientX: s3_touch.clientX,
                clientY: s3_touch.clientY
            });
            s3_canvas.dispatchEvent(s3_mouseEvent);
            e.preventDefault();
        }, false);
        s3_canvas.addEventListener("touchend", function (e) {
            var s3_mouseEvent = new MouseEvent("mouseup", {});
            s3_canvas.dispatchEvent(s3_mouseEvent);
        }, false);
        s3_canvas.addEventListener("touchmove", function (e) {
            var touch = e.touches[0];
            var s3_mouseEvent = new MouseEvent("mousemove", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            s3_canvas.dispatchEvent(s3_mouseEvent);
            e.preventDefault();
            
        }, false);
        
        // Get the position of a touch relative to the canvas
        function s3_getTouchPos(canvasDom, touchEvent) {
            var rect = canvasDom.getBoundingClientRect();
            return {
                s3_x: touchEvent.touches[0].clientX - rect.left,
                s3_y: touchEvent.touches[0].clientY - rect.top
            };
        }
        
        function s3_findxy(res, e){
            const rect = s3_canvas.getBoundingClientRect();
            if (res == 'down') {
                s3_prevX = s3_currX;
                s3_prevY = s3_currY;
                s3_currX = e.clientX - rect.left ;
                s3_currY = e.clientY -  rect.top;
                
                s3_flag = true;
                s3_dot_flag = true;
                if (s3_dot_flag) {
                    s3_ctx.beginPath();
                    s3_ctx.fillStyle = s3_x;
                    s3_ctx.fillRect(s3_currX, s3_currY, 2, 2);
                    s3_ctx.closePath();
                    s3_dot_flag = false;
                }
            }
            if (res == 'up' || res == "out") {
                s3_flag = false;
            }
            if (res == 'move') {
                if (s3_flag) {
                    s3_prevX = s3_currX;
                    s3_prevY = s3_currY;
                    s3_currX = e.clientX -  rect.left;
                    s3_currY = e.clientY - rect.top;
                    s3_draw(component,ctx);
                }
            }
        }
        function s3_draw() {
            
            s3_ctx.beginPath();
            s3_ctx.moveTo(s3_prevX, s3_prevY);
            s3_ctx.lineTo(s3_currX, s3_currY);
            s3_ctx.strokeStyle = s3_x;
            s3_ctx.lineWidth = s3_y;
            s3_ctx.stroke();
            
            s3_ctx.closePath();
        }
        }catch(e){
            
            console.log('--Sign3--Erro'+e.message);
        }
        
       /** Signature 3 canvas ends here **/
         /** Signature 4 canvas start here **/
        try{
        var s4_canvas, s4_ctx, s4_flag = false,
            s4_prevX = 0,
            s4_currX = 0,
            s4_prevY = 0,
            s4_currY = 0,
            s4_dot_flag = false;
        
        var s4_x = "blue",
            s4_y = 2,
            s4_w,s4_h;
        s4_canvas=component.find('canvasSign4').getElement();
       
        var s4_ratio = Math.max(window.devicePixelRatio || 1, 1);
        s4_w = s4_canvas.width*s4_ratio;
        s4_h = s4_canvas.height*s4_ratio;
        s4_ctx = s4_canvas.getContext("2d");
                            
        s4_canvas.addEventListener("mousemove", function (e) {
            s4_findxy('move', e)
        }, false);
        s4_canvas.addEventListener("mousedown", function (e) {
            s4_findxy('down', e)
        }, false);
        s4_canvas.addEventListener("mouseup", function (e) {
            s4_findxy('up', e)
        }, false);
        s4_canvas.addEventListener("mouseout", function (e) {
            s4_findxy('out', e)
        }, false);
        // Set up touch events for mobile, etc
        s4_canvas.addEventListener("touchstart", function (e) {
            var s4_touch = e.touches[0];
           // console.log('touch start:='+s4_touch);
            var s4_mouseEvent = new MouseEvent("mousedown", {
                clientX: s4_touch.clientX,
                clientY: s4_touch.clientY
            });
            s4_canvas.dispatchEvent(s4_mouseEvent);
            e.preventDefault();
        }, false);
        s4_canvas.addEventListener("touchend", function (e) {
            var s4_mouseEvent = new MouseEvent("mouseup", {});
            s4_canvas.dispatchEvent(s4_mouseEvent);
        }, false);
        s4_canvas.addEventListener("touchmove", function (e) {
            var touch = e.touches[0];
            var s4_mouseEvent = new MouseEvent("mousemove", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            s4_canvas.dispatchEvent(s4_mouseEvent);
            e.preventDefault();
            
        }, false);
        
        // Get the position of a touch relative to the canvas
        function s4_getTouchPos(canvasDom, touchEvent) {
            var rect = canvasDom.getBoundingClientRect();
            return {
                s4_x: touchEvent.touches[0].clientX - rect.left,
                s4_y: touchEvent.touches[0].clientY - rect.top
            };
        }
        
        function s4_findxy(res, e){
            const rect = s4_canvas.getBoundingClientRect();
            if (res == 'down') {
                s4_prevX = s4_currX;
                s4_prevY = s4_currY;
                s4_currX = e.clientX - rect.left ;
                s4_currY = e.clientY -  rect.top;
                
                s4_flag = true;
                s4_dot_flag = true;
                if (s4_dot_flag) {
                    s4_ctx.beginPath();
                    s4_ctx.fillStyle = s4_x;
                    s4_ctx.fillRect(s4_currX, s4_currY, 2, 2);
                    s4_ctx.closePath();
                    s4_dot_flag = false;
                }
            }
            if (res == 'up' || res == "out") {
                s4_flag = false;
            }
            if (res == 'move') {
                if (s4_flag) {
                    s4_prevX = s4_currX;
                    s4_prevY = s4_currY;
                    s4_currX = e.clientX -  rect.left;
                    s4_currY = e.clientY - rect.top;
                    s4_draw(component,ctx);
                }
            }
        }
        function s4_draw() {
            
            s4_ctx.beginPath();
            s4_ctx.moveTo(s4_prevX, s4_prevY);
            s4_ctx.lineTo(s4_currX, s4_currY);
            s4_ctx.strokeStyle = s4_x;
            s4_ctx.lineWidth = s4_y;
            s4_ctx.stroke();
            
            s4_ctx.closePath();
        }
        }catch(e){
            
            console.log('--Sign--Erro'+e.message);
        }
        
       /** Signature 4 canvas ends here **/



    },
        
    /*    erase : function(component, event, helper){
            var logs = JSON.parse(myStorage.getItem("__log"));
            
            if(logs.length > 0)
            {
                temp.unshift(logs.shift());
                
                setTimeout(function(){
                    myStorage.setItem("__log", JSON.stringify(logs));
                    helper.setImageURLforMarking(component);
                    var canvas=component.find('canvasDia').getElement();
                    var img = component.find('customImg').getElement(); 
                    var ctx = canvas.getContext("2d");
                    var w = canvas.width;
                    var h = canvas.height;
                    ctx.clearRect(0, 0, w, h);
                    ctx.drawImage(img, 0,0,w,h);
                    
                    
                    
                    var img = new Image();
                    img.src =logs[0]['png'];
                    
                    img.onload = function() {
                        ctx.drawImage(img, 0, 0);
                    }
                    
                }, 0);
            }
        },*/
    
     erase : function(component, event, helper){
        var m = confirm("Do you Want to clear?");
        if (m) {
            helper.setImageURLforMarking(component);
            var canvas=component.find('canvasDia').getElement();
            var img = component.find('customImg').getElement(); 
            var ctx = canvas.getContext("2d");
            var w = canvas.width;
            var h = canvas.height;
            ctx.clearRect(0, 0, w, h);
            ctx.drawImage(img, 0,0,w,h);
        }
    },
        
    eraseSign : function(component, event, helper){
        var m = confirm("Do you Want to clear?");
        if (m) {
            var canvas=component.find('canvasSign').getElement();
            var ctx = canvas.getContext("2d");
            var w = canvas.width;
            var h = canvas.height;
            ctx.clearRect(0, 0, w, h);
           
        }
    },
    eraseSign2 : function(component, event, helper){
        var m = confirm("Do you Want to clear?");
        if (m) {
            var canvas=component.find('canvasSign2').getElement();
            var ctx = canvas.getContext("2d");
            var w = canvas.width;
            var h = canvas.height;
            ctx.clearRect(0, 0, w, h);
           
        }
    },
    
    eraseSign3 : function(component, event, helper){
        var m = confirm("Do you Want to clear?");
        if (m) {
            var canvas=component.find('canvasSign3').getElement();
            var ctx = canvas.getContext("2d");
            var w = canvas.width;
            var h = canvas.height;
            ctx.clearRect(0, 0, w, h);
           
        }
    },
    eraseSign4 : function(component, event, helper){
        var m = confirm("Do you Want to clear?");
        if (m) {
            var canvas=component.find('canvasSign4').getElement();
            var ctx = canvas.getContext("2d");
            var w = canvas.width;
            var h = canvas.height;
            ctx.clearRect(0, 0, w, h);
           
        }
    },

    customHandleSubmit :  function(component, event, helper) {
        
        let btnVal = event.getSource().get("v.name");
        component.set('v.InspStatus',btnVal);
        
       },
    
     handleSubmit : function(component, event, helper) {
         event.preventDefault();
         var sign=component.find('canvasSign').getElement();
         var sign2=component.find('canvasSign2').getElement();
         var sign3=component.find('canvasSign3').getElement();
         var sign4=component.find('canvasSign4').getElement();
         
         var eventFields = event.getParam("fields");
         eventFields["Inspection_Status__c"] =  component.get('v.InspStatus');
         let comments = component.get('v.comments');
          
        
      
          let inspector2 = component.find('inspector2').get('v.value');
          let inspector3 = component.find('inspector3').get('v.value');
          let inspector4 = component.find('inspector4').get('v.value');
          
         
         if(!comments && component.get('v.InspStatus') === 'Reject') {
             helper.showToast('Warning','warning','Comments are required');
         }else if(sign.toDataURL().length < 3000){
             helper.showToast('Warning','warning','Signature is required');
             var canvas=component.find('canvasSign').getElement();
             var ctx = canvas.getContext("2d");
             var w = canvas.width;
             var h = canvas.height;
             ctx.clearRect(0, 0, w, h); 
             
         }else if(sign2.toDataURL().length < 3000 && inspector2){
             helper.showToast('Warning','warning','Inspector 2 Signature is required');
             var canvas=component.find('canvasSign2').getElement();
             var ctx = canvas.getContext("2d");
             var w = canvas.width;
             var h = canvas.height;
             ctx.clearRect(0, 0, w, h); 
             
         }else if(sign3.toDataURL().length < 3000 && inspector3){
             helper.showToast('Warning','warning','Inspector 3 Signature is required');
             var canvas=component.find('canvasSign3').getElement();
             var ctx = canvas.getContext("2d");
             var w = canvas.width;
             var h = canvas.height;
             ctx.clearRect(0, 0, w, h); 
             
         }else if(sign4.toDataURL().length < 3000 && inspector4){
             helper.showToast('Warning','warning','Inspector 4 Signature is required');
             var canvas=component.find('canvasSign4').getElement();
             var ctx = canvas.getContext("2d");
             var w = canvas.width;
             var h = canvas.height;
             ctx.clearRect(0, 0, w, h); 
             
         }else {
             //alert('save')
             
             component.find('insForm').submit(eventFields);
             
         }
          },
    
    handleSuccess : function(component, event, helper) {
        
        component.set("v.toggleSpinner",true);
        
        try{
        let uploadedDiagram = component.get("v.uploadedDiagram");
         
        var diagram=component.find('canvasDia').getElement();
        var sign=component.find('canvasSign').getElement();
        var sign2=component.find('canvasSign2').getElement();
        var sign3=component.find('canvasSign3').getElement();
        var sign4=component.find('canvasSign4').getElement();
        let inspector2 = component.find('inspector2').get('v.value');
        let inspector3 = component.find('inspector3').get('v.value');
        let inspector4 = component.find('inspector4').get('v.value');
         
         var ctx = sign.getContext("2d");          
         ctx.globalCompositeOperation = "destination-over";
         ctx.fillStyle = "#FFF"; //white
         ctx.fillRect(0,0,sign.width, sign.height);
        
         
         var ctx2 = sign2.getContext("2d");          
         ctx2.globalCompositeOperation = "destination-over";
         ctx2.fillStyle = "#FFF"; //white
         ctx2.fillRect(0,0,sign2.width, sign2.height);
        
         var ctx3 = sign3.getContext("2d");          
         ctx3.globalCompositeOperation = "destination-over";
         ctx3.fillStyle = "#FFF"; //white
         ctx3.fillRect(0,0,sign3.width, sign3.height);
        
         var ctx4 = sign4.getContext("2d");          
         ctx4.globalCompositeOperation = "destination-over";
         ctx4.fillStyle = "#FFF"; //white
         ctx4.fillRect(0,0,sign4.width, sign4.height);
         
       
         uploadedDiagram.push({
             'strFileName':'MarkedDiagram.png',
             'strFileType':'image/png',
             'strBase64Data':diagram.toDataURL()
             
         }); 
         uploadedDiagram.push({
             'strFileName':'Sign.png',
             'strFileType':'image/png',
             'strBase64Data':sign.toDataURL()
             
         }); 
        if(inspector2){
            uploadedDiagram.push({
                'strFileName':'Sign2.png',
                'strFileType':'image/png',
                'strBase64Data':sign2.toDataURL()
                
            }); 
        }
        if(inspector3){
            uploadedDiagram.push({
                'strFileName':'Sign3.png',
                'strFileType':'image/png',
                'strBase64Data':sign3.toDataURL()
                
            }); 
        }
        if(inspector4){
            uploadedDiagram.push({
                'strFileName':'Sign4.png',
                'strFileType':'image/png',
                'strBase64Data':sign4.toDataURL()
                
            }); 
        }
        var params = event.getParams();
        let imgList = component.get("v.uploadedImgList")
        let Diagram2 = component.get("v.uploadedDiagram");
        let finalDocList = imgList.concat(Diagram2);
        //console.log('---'+finalDocList.length);
        //console.log('----'+JSON.stringify(finalDocList));
        var action = component.get('c.addImagesToRecId');
        action.setParams({
            recordId : params.response.id,
            imgData:JSON.stringify(finalDocList)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                helper.showToast('success','success','Inspection form has been saved successfully');
                
                var pageChangeEvent = component.getEvent("goToHomePage");
                pageChangeEvent.fire();
                 
            }
            else if (state === "ERROR") {
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        component.set("v.toggleSpinner",false);
                         helper.showToast('Error','Error','Error-'+errors[0].message);
                
                        
                    }
                } else {
                    console.log("Unknown error");
                    component.set("v.toggleSpinner",false);
                    
                }
            }
          }); 
        
        $A.enqueueAction(action);  
        }catch(e){
            console.log(e.message);
        }
      
    },
    handleError : function(component, event, helper) {
        
        helper.showToast('Error','Error','Error-'+error);
        console.log('--Handle error--');
        var error = event.getParam("error");
        component.set("v.toggleSpinner",false);
        console.log(error);
        
    },
    
    OnUpload : function(component, event, helper) {
          try{
             var files = component.get("v.uploadedDocs");
             
              var fileUploadWrapper = component.get("v.uploadedImgList");
              //var imgPreview =document.getElementById("imgPreview");
              var contentWrapperArr = [];
           
             if(files && files.length > 0) {
                for(var i=0; i < files[0].length; i++){
                  var file = files[0][i];
                    
                    
                    if(file.size ) { //< 2000000
                        var reader = new FileReader();
                        reader.name = file.name;
                        reader.type = file.type;
                      
                        reader.onloadend = function(e) {
                            
                            console.log(e.target.result.length);
                            try{
                                var ctx;
                                var img = new Image();
                                img.src = e.target.result;
                                var imgName = e.target.name;
                                var imgType = e.target.type;
                                 img.onload = function() {
                                  
                                  var w = img.naturalWidth;
                                  var h = img.naturalHeight;
                                     
                                var canvas = document.createElement("canvas");
                                var scaleFactor = 500 / w;
                                canvas.width = 500;
                                canvas.height = h*scaleFactor;
                             
                                ctx = canvas.getContext("2d");
                                ctx.drawImage(img, 0, 0, 500, h*scaleFactor);
                                     
                                     var newDataUrl = canvas.toDataURL('image/jpeg',0.5);
                                     //var tarRes =  downscaleImage(e.target.result, 200,'image/jpeg',0.7) ;
                                     //console.log(newDataUrl.length);
                                     //console.log(newDataUrl);
                                     if(newDataUrl.length < 1000000){
                                         fileUploadWrapper.push({
                                             'strFileName':imgName,
                                             'strFileType':imgType,
                                             'strBase64Data':newDataUrl
                                             
                                         });
                                         contentWrapperArr.push({
                                             'strFileName':imgName,
                                             'strFileType':imgType,
                                             'strBase64Data':newDataUrl                      
                                         });
                                         component.set("v.uploadedImgList",fileUploadWrapper);
                                         
                                         var start=component.get('v.start');
                                         var corousalSize=component.get('v.corousalSize');
                                         //start+=corousalSize;
                                         let imgList=component.get('v.uploadedImgList'); 
                                         component.set("v.noofUploadImg",imgList.length);
                                         if(imgList.length > corousalSize){
                                             component.set("v.carouselImgList",imgList.slice(start,start+corousalSize));
                                         }else{
                                              component.set("v.carouselImgList",imgList);
                                         }
                                         
                                     }else {
                                         
                                         helper.showToast('warning','warning','Image size must be less than 1MB');
                                     }
                                 }
                            }catch(e){
                                console.log('--err-'+e.message);
                            }
                            
                            
                            
                        }
                        
                        function handleEvent(event) {
                            if(contentWrapperArr.length == i){
                                
                                component.set("v.uploadedImgList",fileUploadWrapper);
                            }
                        }
                        reader.readAsDataURL(file);
                        reader.addEventListener('loadend', handleEvent);
                        
                    }
                    
             
                   }
              }
               //console.log('--data--'+ JSON.stringify(component.get("v.uploadedImgList")));
        }catch(e){
            console.log('---'+e.message);
        }
      
       
                            
    },
    
     getPreviousList: function(component, event, helper) {
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start-=corousalSize;
        var imgList=component.get('v.uploadedImgList'); 
        component.set('v.carouselImgList',imgList.slice(start,start+corousalSize)); 
        component.set('v.start',start);
        
    },
    getNextList: function(component, event, helper) {
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start+=corousalSize;
        var imgList=component.get('v.uploadedImgList'); 
        component.set('v.carouselImgList',imgList.slice(start,start+corousalSize)); 
        component.set('v.start',start); 
    },
    
    removeImg : function(component, event, helper) {
        
        var index = event.target.dataset.index;
        var toremovefile = event.currentTarget.dataset.filename;
              
        
        var removefileToBeUploaded= component.get("v.uploadedImgList");
        removefileToBeUploaded.splice(index, 1);
        component.set("v.uploadedImgList", removefileToBeUploaded);
        
         var removefile = component.get("v.carouselImgList");
        removefile.splice(index, 1);
        component.set("v.carouselImgList", removefile);
        
        let imgList = component.get("v.uploadedImgList");
        component.set("v.noofUploadImg",imgList.length);
        
        
        var start=0;
        var corousalSize=component.get('v.corousalSize');
        component.set("v.start",0);
        let uploadList=component.get('v.uploadedImgList'); 
        component.set("v.noofUploadImg",uploadList.length);
        if(uploadList.length > corousalSize){
            component.set("v.carouselImgList",uploadList.slice(start,start+corousalSize));
        }else{
            component.set("v.carouselImgList",uploadList);
        }
    },
    
     goToHomePage : function(component, event, helper) {
        
        var pageChangeEvent = component.getEvent("goToHomePage");
        pageChangeEvent.fire();
              
    },
    showWaiting : function(component, event, helper) {component.set("v.toggleSpinner",true)},
    
    hideWaiting: function(component, event, helper) {component.set("v.toggleSpinner",false)},
    
    scriptsLoaded : function(component, event, helper) {
        
        console.log('script loaded')
        try{
            const compress = new Compress();
        }catch(e){
            console.log('err'+e.message);
        }
    },
    
    printPDF : function(component, event, helper){
   
      window.open("../apex/CICO_InspectionPdfPage?id="+component.get("v.vehicelSpecId"), "Print Document");
        
	},
    
  DateValidation : function(component, event, helper){
        
       let data =  event.getSource().get('v.value');
       let id =  event.getSource().getLocalId();
       let today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
       let ele = component.find(id);
        if(data > today){
             
           helper.showToast('warning','warning','Date should not be future date');
            try{
                            
                //component.find(id).set("v.value",'');
             
                $A.util.addClass(ele, 'slds-has-error');
                
            }catch(e){
                console.log(e.message);
            }
           
        }else {
            $A.util.removeClass(ele, 'slds-has-error');
        }
     },
    
    numberValidation : function(component,event,helper){
       
        if (event.key.match(/[0-9 ]/g) ||event.key =='Backspace' ||event.key =='Delete'){
            
            
        } else {
            event.preventDefault();
            
        }
    },
    textValidation : function(component,event,helper){
       
        if (event.key.match(/[a-zA-Z ]/g) ||event.key =='Backspace' ||event.key =='Delete'){
            
            
        } else {
            event.preventDefault();
            
        }
    },
    setAssetTypeImg : function(component,event,helper){
        let assetMaster = ['Car','Electric-Car','Motorcycle','Pickup','Mini-Bus'];
        
        let assetType = event.getSource().get("v.value");
        
        if(!assetMaster.includes(assetType)){
            component.set("v.showInspectors",true);
        }else{
             component.set("v.showInspectors",false);
        }            
                
        component.set("v.assetType",assetType);
        helper.setImageURLforMarking(component);
       
    },
    onloadHandler : function(component,event,helper){
                
        let assetType = component.find('AssetType').get('v.value');
        let assetMaster = ['Car','Electric-Car','Motorcycle','Pickup'];
        if(!assetMaster.includes(assetType)){
            component.set("v.showInspectors",true);
        }else{
             component.set("v.showInspectors",false);
        }  
        console.log('asset==>'+assetType);
    },
    
     
    handleUploadFinished : function(component, event, helper) {
        
        var uploadedFiles = event.getParam("files");
        console.log(uploadedFiles)
        
        var documentId = uploadedFiles[0].documentId;
        
        console.log('---'+documentId);
        
    },
    
    onForceLoad : function(component, event, helper) {
        
        var data = component.get("v.record");
        
        component.set("v.sliderVal",data.Fuel_Tank_Capacity__c);
                  
            let vol = component.find("vol").getElement();
            vol.style = generateBackground(data.Fuel_Tank_Capacity__c);           
                      
            function generateBackground(val){
                let color1 = '';
                let color2 = '';
                let color3 = '';
                if (val === 0) {
                    return
                }
                if(val <= 70){
                     color1 = '#f03e3e';
                     color2 = '#f03e3e';
                     color3 = '#30b32d';
                }
                if(val > 70){
                     color1 = '#30b32d';
                     color2 = '#30b32d';
                     color3 = '#30b32d';
                }
                
                let percentage =  (val - 0) / (100 - 0) * 100
               return 'background: linear-gradient(to right,'+color1+','+color2+' ' + percentage + '%, #d3edff ' + percentage + '%, #dee1e2 100%)'
                
            }
        
        
        component.set("v.inspector2Id",data.Inspector2__c);
        component.set("v.inspector2Name",data.Inspector2__r.Name);
        
        component.set("v.inspector3Id",data.Inspector3__c);
        component.set("v.inspector3Name",data.Inspector3__r.Name);
        
        component.set("v.inspector4Id",data.Inspector4__c);
        component.set("v.inspector4Name",data.Inspector4__r.Name);
    },
    
    sliderHandler : function(component, event, helper) {
         var val = component.get("v.sliderVal");
     
    }
    
    
})