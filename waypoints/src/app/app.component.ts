import { Component } from '@angular/core';
import { MouseEvent } from '@agm/core';

import {GoogleMapsAPIWrapper} from '@agm/core';
import { saveAs } from 'file-saver/FileSaver';

declare var google: any;
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: [ './app.component.css' ]
})
export class AppComponent  {
  zoom: number = 8;
  
  lat: number = 51.673858;
  lng: number = 7.815982;
  dir;
  onNgInit(){
    
      this.dir = {
        org: { lat: 24.799448, lng: 120.979021 },
        dest: { lat: 24.799524, lng: 120.975017 }
      }
  }
    

  clickedMarker(label: string, index: number) {
    console.log(`clicked the marker: ${label || index}`)
  }
  
  mapClicked($event: MouseEvent) {

    this.markers.push({
      lat: $event.coords.lat,
      lng: $event.coords.lng,
      label: "Marker " + (this.markers.length+1),
      draggable: true
    });
  }

  markerDragEnd(i, $event: MouseEvent) {
    this.markers[i].lat = $event.coords.lat;
    this.markers[i].lng = $event.coords.lng;
  }
  
  markers: marker[] = []
  waypoints: any[] = [];
  tourpoints: any[] = [];
  tours: any[] = [];

  public saveWay(): void{

  	this.waypoints = [];
  	for(var i=0; i<this.markers.length; i++){
  		this.waypoints.push({lat: this.markers[i].lat, lng: this.markers[i].lng});
  	}
  	console.log(this.waypoints[1].lat);
  }

  public removeWaypoint(index): void{
  	this.waypoints.splice(index, 1);
  	this.markers.splice(index, 1);
  }

  public addPoints($event, i): void{
  	if($event.target.checked){
	  	this.tourpoints.push({
	  		lat: this.waypoints[i].lat,
	  		lng: this.waypoints[i].lng
	  	});
	}else{
		var thisindex = this.tourpoints.indexOf({
	  		lat: this.waypoints[i].lat,
	  		lng: this.waypoints[i].lng
	  	});
		this.tourpoints.splice(thisindex, 1);
	}
  }

  public removeTourWaypoints(tourindex, waypointIndex): void{
  	this.tours[tourindex].waypoints.splice(waypointIndex, 1);
  }

  public saveTour(): void{
  	var thisTour = {start: {}, waypoints: [], destination: {} };
  	for(var i=0; i<this.tourpoints.length; i++){
  		if(i==0){
  			thisTour.start = {
	  			lat: this.tourpoints[i].lat,
	  			lng: this.tourpoints[i].lng
	  		}
  		}

  		else if(i==this.tourpoints.length-1){
  			thisTour.destination = {
	  			lat: this.tourpoints[i].lat,
	  			lng: this.tourpoints[i].lng
	  		}
  		}
  		else {
	  		thisTour.waypoints.push({
	  			lat: this.tourpoints[i].lat,
	  			lng: this.tourpoints[i].lng
	  		});
	  	}
  	}
  	this.tours.push(thisTour);
  	console.log(this.tours);
  }

  public removeTour(index): void{
  	this.tours.splice(index, 1);
  }

  private dispatchWaypoint() {
    var waypointData = JSON.stringify(this.waypoints);

    const blob = new Blob([waypointData], { type: 'text/json' });
    saveAs(blob, 'waypoints.json');
  }

  private dispatchTour() {
    var tourData = JSON.stringify(this.tours);
    
    const blob = new Blob([tourData], { type: 'text/json' });
    saveAs(blob, 'tours.json');
  }
}

// just an interface for type safety.
interface marker {
	lat: number;
	lng: number;
	label?: string;
	draggable: boolean;
}