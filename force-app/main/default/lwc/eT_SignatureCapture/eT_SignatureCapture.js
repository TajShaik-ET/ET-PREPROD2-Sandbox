import { LightningElement, api, track, wire } from 'lwc';

let canvasElement, ctx,cts,SigcanvasElement,Sigimg, flag = false, dot_flag = false, prevX = 0,
	currX = 0, prevY = 0,
	currY = 0, x = "red", y = 2, w, h, img, signx="blue";
let storageArray = [];
let cStep = 0;
let SigcStep = 0;
let attachment; //holds attachment information after saving the sigture on canvas
let dataURL, convertedDataURI; //holds image data
export default class ET_SignatureCapture extends LightningElement {
	@api hasRendered;
	fileData;
    renderedCallback() {

        if (this.hasRendered) {
			
			///signature-Capture
			let SigcanvasQuery = this.template.querySelector('[data-id="canvasSig"]');
			if(SigcanvasQuery){
			SigcanvasQuery.addEventListener('mousemove', (e) => { this.SigsearchCoordinatesForEvent('move', e) });
			SigcanvasQuery.addEventListener('mousedown', (e) => { this.SigsearchCoordinatesForEvent('down', e) });
			SigcanvasQuery.addEventListener('mouseup', (e) => { this.SigsearchCoordinatesForEvent('up', e) });
			SigcanvasQuery.addEventListener('mouseout', (e) => { this.SigsearchCoordinatesForEvent('out', e) });

			SigcanvasQuery.addEventListener('touchstart', (e) => {

				var touch = e.touches[0];
				var mouseEvent = new MouseEvent("mousedown", {
					clientX: touch.clientX,
					clientY: touch.clientY
				});
				SigcanvasQuery.dispatchEvent(mouseEvent);
				e.preventDefault();
			});
			SigcanvasQuery.addEventListener('touchend', (e) => {

				this.SigsearchCoordinatesForEvent('up', e)
			});
			SigcanvasQuery.addEventListener('touchmove', (e) => {

				var touch = e.touches[0];
				var mouseEvent = new MouseEvent("mousemove", {
					clientX: touch.clientX,
					clientY: touch.clientY
				});
				SigcanvasQuery.dispatchEvent(mouseEvent);
				e.preventDefault();
			});
		
			SigcanvasElement = SigcanvasQuery;
			cts = SigcanvasElement.getContext("2d");
			Sigimg = new Image();
			//Sigimg.src = imageResource;
			Sigimg.onload = () => {
				cts.drawImage(Sigimg, 0, 0, SigcanvasElement.width, SigcanvasElement.height);
			}
			this.hasRendered = false;
		}
		}

    }

    /*Signature Capture*/
    SigsearchCoordinatesForEvent(requestedEvent, e) {
		e.preventDefault();
		const rect = SigcanvasElement.getBoundingClientRect();

		if (requestedEvent == 'down') {
			prevX = currX;
			prevY = currY;
			currX = e.clientX - rect.left;
			currY = e.clientY - rect.top;

			flag = true;
			dot_flag = true;
			if (dot_flag) {
				cts.beginPath();
				cts.fillStyle = signx;
				cts.fillRect(currX, currY, 2, 2);
				cts.closePath();
				dot_flag = false;
			}
		}
		if (requestedEvent == 'up' || requestedEvent == "out") {
			flag = false;
			if (requestedEvent == 'up')
				this.SigcPush();
		}

		if (requestedEvent == 'move') {
			if (flag) {
				prevX = currX;
				prevY = currY;
				currX = e.clientX - rect.left;
				currY = e.clientY - rect.top;
				this.Sigdraw();
			}
		}
	}

	Sigdraw() {
		cts.beginPath();
		cts.moveTo(prevX, prevY);
		cts.lineTo(currX, currY);
		cts.strokeStyle = signx;
		cts.lineWidth = y;
		cts.stroke();
		cts.closePath();
	}
	SigclearDrawing() {
		cts.clearRect(0, 0, SigcanvasElement.width, SigcanvasElement.height);
		cts.drawImage(Sigimg, 0, 0, SigcanvasElement.width, SigcanvasElement.height);
		SigcStep = 0;
	}

	SigcPush() {
		try {
			SigcStep++;

			if (SigcStep < storageArray.length) {
				storageArray.length = SigcStep;
			}
			//storageArray.push(SigcanvasElement.toDataURL());
			cts.globalCompositeOperation = "destination-over";
			cts.fillStyle = "#FFF"; //white
			cts.fillRect(0, 0, SigcanvasElement.width, SigcanvasElement.height);
			dataURL = SigcanvasElement.toDataURL("image/png");
			convertedDataURI = dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
			this.fileData = {
				'filename': 'Customer Signature.png',
				'filetype': 'image/png',
				'base64': convertedDataURI,
			}
			//storageArray.push(this.fileData)
			
			//passing to parent
			//console.log('storageArrayin child'+this.fileData)
			const event = new CustomEvent('child', {
				detail: {
					CustomerSigCapture: this.fileData
				}
			});
			this.dispatchEvent(event);
		
		} catch (e) {
			console.log(e.message)
		}
	}




}