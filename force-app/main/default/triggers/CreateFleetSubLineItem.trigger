trigger CreateFleetSubLineItem on Fleet_Inspection_Line_Item__c (after insert) {
    
    if(Trigger.isAfter){
        
        Map<Id,String> multipicklistvalueMap =new Map<Id,String>();
        
        for(Fleet_Inspection_Line_Item__c fleetlineItem :Trigger.New){
            
         String Multipicklist = fleetlineItem.ETT_Bad_Reason_Complaint__c;
            System.debug('Multipicklist='+Multipicklist);
            if(fleetlineItem.ETT_Bad_Reason_Complaint__c!=null && fleetlineItem.ETT_Bad_Reason_Complaint__c!=''){
                multipicklistvalueMap.put(fleetlineItem.id,Multipicklist);
                          
            }
            
            
        }
        
        List<ETT_Fleet_Inspection_Sub_Line_Item__c> newFleetSubLineItems = new List<ETT_Fleet_Inspection_Sub_Line_Item__c>();
        for(Id LineItemID :multipicklistvalueMap.keySet())
        {
            String BadReasons = multipicklistvalueMap.get(LineItemID);
            
            if(BadReasons.contains('Spread/Damaged Cord'))
            {
              ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Spread/Damaged Cord';
                sublineObj.ETT_Complaint_Name__c = 'Spread/Damaged Cord';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                sublineObj.StaticResourceImageName__c = 'ETT_SW_SpreadDamagedCord';
                
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Cuts and Snags')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Cuts and Snags';
                sublineObj.ETT_Complaint_Name__c = 'Cuts and Snags';
               sublineObj.ETT_Cause_of_Complaint__c =  Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                 sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Sidewall Separation')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Sidewall Separation';
                sublineObj.ETT_Complaint_Name__c = 'Sidewall Separation';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Sidewall_Seperation_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Sidewall_Seperation_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
              sublineObj.StaticResourceImageName__c =  'ETT_SW_SidewallSeparation';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Chain Damage')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Chain Damage';
                sublineObj.ETT_Complaint_Name__c = 'Chain Damage';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Chain_Damage_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Chain_Damage_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                sublineObj.StaticResourceImageName__c = 'ETT_SW_ChainDamage';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Vehicle/Equipment Damage')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Vehicle/Equipment Damage';
                sublineObj.ETT_Complaint_Name__c = 'Vehicle/Equipment Damage';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Vehicle_Equipment_Damage_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Vehicle_Equipment_Damage_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                 sublineObj.StaticResourceImageName__c = 'ETT_SW_VehicleDamage';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Damage Induced Sidewall Separation')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Damage Induced Sidewall Separation';
                sublineObj.ETT_Complaint_Name__c = 'Damage Induced Sidewall Separation';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Damaged_Induced_Sidewall_Separation_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Damaged_Induced_Sidewall_Separation_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                sublineObj.StaticResourceImageName__c = 'ETT_SW_DamagedInducedSeparation';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Sidewall Abrasion/Scuff Damage')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Sidewall Abrasion/Scuff Damage';
                sublineObj.ETT_Complaint_Name__c = 'Sidewall Abrasion/Scuff Damage';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Sidewall_Abrasion_Scuff_Damage_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                sublineObj.StaticResourceImageName__c = 'ETT_SW_SidewallAbrasionScuffDamage';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Weathering')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Weathering';
                sublineObj.ETT_Complaint_Name__c = 'Weathering';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Weathering_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Weathering_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                sublineObj.StaticResourceImageName__c = 'ETT_SW_Weathering';
                newFleetSubLineItems.add(sublineObj); 
            }
            
             if(BadReasons.contains('Impact Break')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Impact Break';
                sublineObj.ETT_Complaint_Name__c = 'Impact Break';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Impact_Break_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Impact_Break_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_ImpactBreak';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Branding Damage')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Branding Damage';
                sublineObj.ETT_Complaint_Name__c = 'Branding Damage';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Branding_Damage_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Branding_Damage_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_BrandingDamage';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Aging Crack/Weatheringe')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Aging Crack/Weathering';
                sublineObj.ETT_Complaint_Name__c = 'Aging Crack/Weathering';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Weathering_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Weathering_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_Weathering';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Diagonal Cracking')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Diagonal Cracking';
                sublineObj.ETT_Complaint_Name__c = 'Diagonal Cracking';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Diagonal_Cracking_Probale_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Diagonal_Cracking_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_DiagnoalCracking';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Petroleum Product Damage')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Petroleum Product Damage';
                sublineObj.ETT_Complaint_Name__c = 'Petroleum Product Damage';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Petroleum_Product_Damage_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Petroleum_Product_Damage_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_PetroleumProductDamage';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Forklift Damage')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Forklift Damage';
                sublineObj.ETT_Complaint_Name__c = 'Forklift Damage';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Forklift_Damage_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Forklift_Damage_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_ForkliftDamage';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Circumferential Fatigue Rupture (Zipper)')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Circumferential Fatigue Rupture (Zipper)';
                sublineObj.ETT_Complaint_Name__c = 'Circumferential Fatigue Rupture (Zipper)';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Circumferential_Fatigue_Repture_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Circumferential_Fatigue_Repture_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_CircumFatigueRupture';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Open Sidewall Splice')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Open Sidewall Splice';
                sublineObj.ETT_Complaint_Name__c = 'Open Sidewall Splice';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Open_sidewall_Splice_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Open_sidewall_Splice_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_OpensidewallSplice';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Sidewall Bumps (Blisters)')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Sidewall Bumps (Blisters)';
                sublineObj.ETT_Complaint_Name__c = 'Sidewall Bumps (Blisters)';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Sidewall_Bumps_Blisters_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Sidewall_Bumps_Blisters_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_SidewallBumps';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Sidewall Penetration')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Sidewall Penetration';
                sublineObj.ETT_Complaint_Name__c = 'Sidewall Penetration';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Sidewall_Penetration_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Sidewall_Penetration_recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_SidewallPenetration';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Torn Bead')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Torn Bead';
                sublineObj.ETT_Complaint_Name__c = 'Torn Bead';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Torn_Bead_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Torn_Bead_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                 sublineObj.StaticResourceImageName__c = 'ETT_Torn_Bead';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Kinked/Distorted Beads Condition')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Kinked/Distorted Beads Condition';
                sublineObj.ETT_Complaint_Name__c = 'Kinked/Distorted Beads Condition';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Kinked_Distorted_Beads_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Bead_Kinked_Distorted_Beads_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                 sublineObj.StaticResourceImageName__c = 'ETT_Kinked_Distorted_Beads';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Bead Deformation')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Bead Deformation';
                sublineObj.ETT_Complaint_Name__c = 'Bead Deformation';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Bead_Bead_Deformation_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Bead_Bead_Deformation_Recommendation;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_Bead_Deformation';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Burned Beads')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Burned Beads';
                sublineObj.ETT_Complaint_Name__c = 'Burned Beads';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Bead_Burned_Beads_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Bead_Burned_Beads_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_Burned_Beads';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Reinforce / Chafer Separation')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Reinforce / Chafer Separation';
                sublineObj.ETT_Complaint_Name__c = 'Reinforce / Chafer Separation';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Bead_Reinforce_Chafer_Seperation_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Bead_Reinforce_Chafer_Seperation_Recommendation;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_Reinforce_Chafer_Separation';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Petro/ Lubricant Damage')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Petro/ Lubricant Damage';
                sublineObj.ETT_Complaint_Name__c = 'Petro/ Lubricant Damage';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Bead_Petro_Lubricant_Damage_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Band_Petro_Lubricant_Damage_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                sublineObj.StaticResourceImageName__c = 'ETT_Petro_Lubricant_Damage';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Bead Damage From Curbing')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Bead Damage From Curbing';
                sublineObj.ETT_Complaint_Name__c = 'Bead Damage From Curbing';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Bead_Bead_Damage_From_Curbing_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   '';
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_Bead_Damage_from_Curbing';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Bead Area Flow Crack')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Bead Area Flow Crack';
                sublineObj.ETT_Complaint_Name__c = 'Bead Area Flow Crack';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Bead_Bead_Area_Flow_Crack_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Bead_Bead_Area_Flow_Crack_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_Bead_Area_Flow_Crack' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Penetrating Object')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Penetrating Object';
                sublineObj.ETT_Complaint_Name__c = 'Penetrating Object';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_SpreadDamagedCord';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Open Inner Liner Splice')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Open Inner Liner Splice';
                sublineObj.ETT_Complaint_Name__c = 'Open Inner Liner Splice';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_SpreadDamagedCord' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Inner Liner Bubbles, Blisters and Separations')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Inner Liner Bubbles, Blisters and Separations';
                sublineObj.ETT_Complaint_Name__c = 'Inner Liner Bubbles, Blisters and Separations';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_SpreadDamagedCord';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Inner Liner Cracking')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Inner Liner Cracking';
                sublineObj.ETT_Complaint_Name__c = 'Inner Liner Cracking';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_SpreadDamagedCord';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Pulled/Loose Cords')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Pulled/Loose Cords';
                sublineObj.ETT_Complaint_Name__c = 'Pulled/Loose Cords';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_SpreadDamagedCord' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Tearing, Mount/Dismount Damage')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Tearing, Mount/Dismount Damage';
                sublineObj.ETT_Complaint_Name__c = 'Tearing, Mount/Dismount Damage';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c =  'ETT_SW_SpreadDamagedCord' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Foreign Object Inner Liner Damage In Tubeless Tyre')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Foreign Object Inner Liner Damage In Tubeless Tyre';
                sublineObj.ETT_Complaint_Name__c = 'Foreign Object Inner Liner Damage In Tubeless Tyre';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_SpreadDamagedCord' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Run Flat')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Run Flat';
                sublineObj.ETT_Complaint_Name__c = 'Run Flat';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_SpreadDamagedCord' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Pinch Shock')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Pinch Shock';
                sublineObj.ETT_Complaint_Name__c = 'Pinch Shock';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_SpreadDamagedCord';
                newFleetSubLineItems.add(sublineObj); 
            }
      
             if(BadReasons.contains('Electrical Discharge')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Electrical Discharge';
                sublineObj.ETT_Complaint_Name__c = 'Electrical Discharge';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Bad Spot Repair')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Bad Spot Repair';
                sublineObj.ETT_Complaint_Name__c = 'Bad Spot Repair';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_SpreadDamagedCord';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Spot Repair Should be a Section Repair')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Spot Repair Should be a Section Repai';
                sublineObj.ETT_Complaint_Name__c = 'Spot Repair Should be a Section Repair';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Improper Nail Hole Repair')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Improper Nail Hole Repair';
                sublineObj.ETT_Complaint_Name__c = 'Improper Nail Hole Repair';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Improperly Aligned repair')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Improperly Aligned repair';
                sublineObj.ETT_Complaint_Name__c = 'Improperly Aligned repair';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Unfilled Nail Hole Repair')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Unfilled Nail Hole Repair';
                sublineObj.ETT_Complaint_Name__c = 'Unfilled Nail Hole Repair';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Bridged Repair')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Bridged Repair';
                sublineObj.ETT_Complaint_Name__c = 'Bridged Repair';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('On the Wheel Repair')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'On the Wheel Repair';
                sublineObj.ETT_Complaint_Name__c = 'On the Wheel Repair';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                 sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags' ;
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Bad Bead Repair')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Bad Bead Repair';
                sublineObj.ETT_Complaint_Name__c = 'Bad Bead Repair';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                 sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Failed Repair – Injury Not Removed')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Failed Repair – Injury Not Removed';
                sublineObj.ETT_Complaint_Name__c = 'Failed Repair – Injury Not Removed';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                 sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags' ;
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Bias Repair in Radial Tyre')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Bias Repair in Radial Tyre';
                sublineObj.ETT_Complaint_Name__c = 'Bias Repair in Radial Tyre';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                 sublineObj.StaticResourceImageName__c =  'ETT_SW_CutsandSnags';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Bridged Repair')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Bridged Repair';
                sublineObj.ETT_Complaint_Name__c = 'Bridged Repair';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                 sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Bond Line Porosity')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Bond Line Porosity';
                sublineObj.ETT_Complaint_Name__c = 'Bond Line Porosity';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                 sublineObj.StaticResourceImageName__c = 'ETT_SW_SpreadDamagedCord';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Tread Separation')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Tread Separation';
                sublineObj.ETT_Complaint_Name__c = 'Tread Separation';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                 sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags' ;
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Tread Chunking at Splice')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Tread Chunking at Splice';
                sublineObj.ETT_Complaint_Name__c = 'Tread Chunking at Splice';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                 sublineObj.StaticResourceImageName__c = 'ETT_SW_RadialSplit' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Tread Separation – Repair Related')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Tread Separation – Repair Related';
                sublineObj.ETT_Complaint_Name__c = 'Tread Separation – Repair Related';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Belt Separation Repair Related')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Belt Separation Repair Related';
                sublineObj.ETT_Complaint_Name__c = 'Belt Separation Repair Related';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Tread Chunking at Splice')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Tread Chunking at Splice';
                sublineObj.ETT_Complaint_Name__c = 'Tread Chunking at Splice';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_RadialSplit' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Missed Puncture')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Missed Puncture';
                sublineObj.ETT_Complaint_Name__c = 'Missed Puncture';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Tread Edge Lifting')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Tread Edge Lifting';
                sublineObj.ETT_Complaint_Name__c = 'Tread Chunking at Splice';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Failed Inner Liner Repair')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Failed Inner Liner Repair';
                sublineObj.ETT_Complaint_Name__c = 'Failed Inner Liner Repair';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_SpreadDamagedCord' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Lug Base Cracking/Tearing')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Lug Base Cracking/Tearing';
                sublineObj.ETT_Complaint_Name__c = 'Lug Base Cracking/Tearing';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Improper Tread Width')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Improper Tread Width';
                sublineObj.ETT_Complaint_Name__c = 'Improper Tread Width';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Redial_Split_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Redial_Split_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_RadialSplit';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Open Tread Splice')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Open Tread Splice';
                sublineObj.ETT_Complaint_Name__c = 'Open Tread Splice';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Redial_Split_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Redial_Split_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_RadialSplit';
                newFleetSubLineItems.add(sublineObj); 
            }
            
             if(BadReasons.contains('Skiving Failure')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Skiving Failure';
                sublineObj.ETT_Complaint_Name__c = 'Skiving Failure';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_SpreadDamagedCord' ;
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Repair Related Bulge')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Repair Related Bulge';
                sublineObj.ETT_Complaint_Name__c = 'Repair Related Bulge';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c = 'ETT_SW_CutsandSnags';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Buckled Tread')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Buckled Tread';
                sublineObj.ETT_Complaint_Name__c = 'Buckled Tread';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Redial_Split_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Redial_Split_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_SW_RadialSplit';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Delamination')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Delamination';
                sublineObj.ETT_Complaint_Name__c = 'Delamination';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Spread_Damaged_Cord_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Spread_Damaged_Cord_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_SW_SpreadDamagedCord';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Tread Surface Porosity')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Tread Surface Porosity';
                sublineObj.ETT_Complaint_Name__c = 'Tread Surface Porosity';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Cust_and_Snags_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.SWA_Cust_and_Snags_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_SW_CutsandSnags';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Wing Lift')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Wing Lift';
                sublineObj.ETT_Complaint_Name__c = 'Wing Lift';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Redial_Split_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Redial_Split_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_SW_RadialSplit';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Failed Repair from Under Inflation')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Failed Repair from Under Inflation';
                sublineObj.ETT_Complaint_Name__c = 'Failed Repair from Under Inflation';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_SWA_Redial_Split_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_SWA_Redial_Split_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_SW_RadialSplit';
                newFleetSubLineItems.add(sublineObj); 
            }
            
            if(BadReasons.contains('Full Shoulder Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Full Shoulder Wear';
                sublineObj.ETT_Complaint_Name__c = 'Full Shoulder Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Crown_fullShoulder_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Crown_fullShoulder_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_Crownarea_FullShoulderwear';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Feather Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Feather Wear';
                sublineObj.ETT_Complaint_Name__c = 'Feather Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_crown_area_feather_wear_Probable;
                sublineObj.ETT_Recommendations__c =   Label.ETT_crown_area_feather_wear_recommendation;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_Crownarea_featherwear';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Erosion/River/Channel Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Erosion/River/Channel Wear';
                sublineObj.ETT_Complaint_Name__c = 'Erosion/River/Channel Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_crown_area_erosion_Probable_cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_crown_area_erosion_recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_Crownareaerosion';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Cupping/Scallop Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Cupping/Scallop Wear';
                sublineObj.ETT_Complaint_Name__c = 'Cupping/Scallop Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Cupping_Scallop_Wear_Probable;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Cuppingrecommendation;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_Cupping_Wear';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Steer Axle One Sided Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Steer Axle One Sided Wear';
                sublineObj.ETT_Complaint_Name__c = 'Steer Axle One Sided Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_One_Sided_Wear_Pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_One_Sided_Wear_Reco;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_ETT_One_Sided_Wear';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Diagonal Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Diagonal Wear';
                sublineObj.ETT_Complaint_Name__c = 'Diagonal Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_crown_area_Diagonal_Wear_pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_crown_area_Diagonal_Wear_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_Crownarea_Diagonalwear';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Eccentric/Out-Of-Round Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Eccentric/Out-Of-Round Wear';
                sublineObj.ETT_Complaint_Name__c = 'Eccentric/Out-Of-Round Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_crown_area_Eccentric_pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Crown_area_Eccentric_recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_Crownarea_Eccentric';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Steer Axle Overall Fast Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Steer Axle Overall Fast Wear';
                sublineObj.ETT_Complaint_Name__c = 'Steer Axle Overall Fast Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Crown_area_Overall_Fast_Wear_pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Crown_area_Overall_Fast_Wear_Recmo;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_SW_RadialSplit';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Rib Depression/Punch Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Rib Depression/Punch Wear';
                sublineObj.ETT_Complaint_Name__c = 'Rib Depression/Punch Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Crown_area_Rib_Depression_Punch_Wear_pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Crown_area_Rib_Crown_area_Depression_Punch_Wear_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_CrownRib';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Erratic Depression Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Erratic Depression Wear';
                sublineObj.ETT_Complaint_Name__c = 'Erratic Depression Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_crown_areaErratic_Depression_Wear_Pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_crown_areaErratic_Depression_Wear_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_crownerratic';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Drive Axle Shoulder Step/Chamfer Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Drive Axle Shoulder Step/Chamfer Wear';
                sublineObj.ETT_Complaint_Name__c = 'Drive Axle Shoulder Step/Chamfer Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_CrownDrive_Axle_Shoulder_StepChamfer_Wear_pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_CrownDrive_Axle_Shoulder_StepChamfer_Wear_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_CrownDriveShoulder';
                newFleetSubLineItems.add(sublineObj); 
            }
           
           
            if(BadReasons.contains('Alternate Lug Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Alternate Lug Wear';
                sublineObj.ETT_Complaint_Name__c = 'Alternate Lug Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_crown_area_Alternate_Lug_Wear_Pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_crown_area_Alternate_Lug_Wear_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_Alternatelugwear';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Break Skid/Flat Spot Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Break Skid/Flat Spot Wear';
                sublineObj.ETT_Complaint_Name__c = 'Break Skid/Flat Spot Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Crown_Break_Skid_Flat_Spot_Wear_pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Crown_Break_Skid_Flat_Spot_Wear_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_CrownBreakskid';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Drive Axle Overall Fast Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Drive Axle Overall Fast Wear';
                sublineObj.ETT_Complaint_Name__c = 'Drive Axle Overall Fast Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Drive_Axle_Overall_Fast_Wear_pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Drive_Axle_Overall_Fast_Wear_recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_Driveaxiloverall';
                newFleetSubLineItems.add(sublineObj); 
            }

             if(BadReasons.contains('Break Skid Flat Spot Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Break Skid Flat Spot Wear';
                sublineObj.ETT_Complaint_Name__c = 'Break Skid Flat Spot Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Trailer_axil_Break_Skid_Flat_Spot_Wear_pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Trailer_axil_Break_Skid_Flat_Spot_Wear_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_TrailerBreakspot';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Multiple Flat Spotting Wire')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Multiple Flat Spotting Wire';
                sublineObj.ETT_Complaint_Name__c = 'Multiple Flat Spotting Wire';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_CrownMultiple_Flat_Spotting_Wire_pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_CrownMultiple_Flat_Spotting_Wire_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_Multiple';
                newFleetSubLineItems.add(sublineObj); 
            }
            
             if(BadReasons.contains('Rapid Shoulder Wear – One Shoulder')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name ='Rapid Shoulder Wear – One Shoulder';
                sublineObj.ETT_Complaint_Name__c = 'Rapid Shoulder Wear – One Shoulder';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Rapid_Shoulder_Wear_One_Shoulder_PRO;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Rapid_Shoulder_Wear_One_Shoulder_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_SW_RadialSplit';
                newFleetSubLineItems.add(sublineObj); 
            }
              if(BadReasons.contains('Heel/Toe Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name ='Heel/Toe Wear';
                sublineObj.ETT_Complaint_Name__c = 'Heel/Toe Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_crown_area_Heel_Toe_Wear_pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_crown_area_Heel_Toe_Wear_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_CrownHeel';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Shoulder Scrubbing/Scuffing Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Shoulder Scrubbing/Scuffing Wear';
                sublineObj.ETT_Complaint_Name__c = 'Shoulder Scrubbing/Scuffing Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Shoulder_Scrubbing_Scuffing_Wear_pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Shoulder_Scrubbing_Scuffing_Wear_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_ShoulderScrubbing';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Rapid Shoulder Wear – Both Shoulder')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Rapid Shoulder Wear – Both Shoulder';
                sublineObj.ETT_Complaint_Name__c = 'Rapid Shoulder Wear – Both Shoulder';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Rapid_Shoulder_Wear_BothShoulder_Pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Rapid_Shoulder_Wear_BothShoulder_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_Rapidbothshoulder';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Erratic Depression Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Erratic Depression Wear';
                sublineObj.ETT_Complaint_Name__c = 'Erratic Depression Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Erratic_Depression_Wear_Pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Erratic_Depression_Wear_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_ErraticDepression';
                newFleetSubLineItems.add(sublineObj); 
            }
             if(BadReasons.contains('Trailer Axle One Sided Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Trailer Axle One Sided Wear';
                sublineObj.ETT_Complaint_Name__c = 'Trailer Axle One Sided Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Trailer_Axle_One_Sided_Wear_pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Trailer_Axle_One_Sided_Wear_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_TrailerAxleOneSided';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Steer Axle Shoulder Step/Chamfer Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Steer Axle Shoulder Step/Chamfer Wear';
                sublineObj.ETT_Complaint_Name__c = 'Steer Axle Shoulder Step/Chamfer Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Crown_Shoulderstep_Probable_Cause;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Crown_Shoulderstep_Recommendations;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_Crownarea_ShoulderStep';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Erosion/River/Channel Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Erosion/River/Channel Wear';
                sublineObj.ETT_Complaint_Name__c = 'Erosion/River/Channel Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Erosion_RiverChannel_Pro;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Erosion_RiverChannel_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_TrailerRiverChannel';
                newFleetSubLineItems.add(sublineObj); 
            }
            if(BadReasons.contains('Rib Depression/Punch Wear')){
                ETT_Fleet_Inspection_Sub_Line_Item__c sublineObj = new ETT_Fleet_Inspection_Sub_Line_Item__c();
               sublineObj.Name = 'Rib Depression/Punch Wear';
                sublineObj.ETT_Complaint_Name__c = 'Rib Depression/Punch Wear';
               sublineObj.ETT_Cause_of_Complaint__c =   Label.ETT_Rib_DepressionPunch_Wear_PRO;
                sublineObj.ETT_Recommendations__c =   Label.ETT_Rib_DepressionPunch_Wear_Recom;
                sublineObj.Fleet_Inspection_Line_Item__c = LineItemID;
                  sublineObj.StaticResourceImageName__c  = 'ETT_TextileRib';
                newFleetSubLineItems.add(sublineObj); 
            }
            
           
            
        }
        
        if(newFleetSubLineItems.size()>0)
        {
            insert newFleetSubLineItems;
             
            list<ContentVersion> lstContentVesions = new list<ContentVersion>();
            Map<String,Id> getsubLineItemIdfromFileName = new Map<String,id>();
            for(ETT_Fleet_Inspection_Sub_Line_Item__c sublineItem:newFleetSubLineItems)
            {
                if(sublineItem.StaticResourceImageName__c!=null)
                {
                    String staticResourseName = sublineItem.StaticResourceImageName__c;
                    StaticResource sr = [Select id,Body,Name,ContentType From StaticResource where Name =:staticResourseName];
                    System.debug('Body='+sr.Body);
                    System.debug('Body='+sr.Name);
                    DateTime dt = DateTime.now();
                    String suffix = dt.format('hh_mm_ss') + '_'+dt.millisecond();
                    String imagenamewithsuffix = sr.Name +'_'+suffix;
                    String fileExtenstion = '';
                    String contentType = sr.ContentType;
                    contentType = contentType.toLowerCase();
                    if(contentType.contains('jpeg'))
                    {
                      fileExtenstion = '.jpg';  
                    }else if(contentType.contains('png'))
                    {
                       fileExtenstion = '.png'; 
                    }
                    String imagename = imagenamewithsuffix + fileExtenstion;
                    System.debug('Body='+sr.ContentType);
                    Blob image = sr.Body; 
                      ContentVersion objContentVersion = new ContentVersion();
                      //      objContentVersion.ContentLocation = 'S';
                     objContentVersion.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(image));
                    //objContentVersion.VersionData =sr.Body;
                            objContentVersion.Title =imagenamewithsuffix;
                            objContentVersion.PathOnClient = imagename;
                            lstContentVesions.add(objContentVersion);
                    getsubLineItemIdfromFileName.put(imagenamewithsuffix,sublineItem.id);
                    
                }
            }
            
            if(lstContentVesions.size()>0)
            {
                insert lstContentVesions;
                Map<ID,ID> mapofContentVersionIdwithContentDocumentIds = new Map<ID,ID>();
                 list<ContentDocumentLink> lstContentDocumentLinks = new list<ContentDocumentLink>();
                for(ContentVersion objContentVersion :[Select Id,ContentDocumentId,Title from ContentVersion where Id in :lstContentVesions]){
                      mapofContentVersionIdwithContentDocumentIds.put(objContentVersion.Id,objContentVersion.ContentDocumentId);
                    }
                    
                    for(ContentVersion objContentVersion :lstContentVesions){
                        ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
                        objContentDocumentLink.LinkedEntityId = getsubLineItemIdfromFileName.containsKey(objContentVersion.Title)?getsubLineItemIdfromFileName.get(objContentVersion.Title):null;
                        objContentDocumentLink.ShareType = 'V';
                        objContentDocumentLink.ContentDocumentId = mapofContentVersionIdwithContentDocumentIds.containsKey(objContentVersion.Id)?mapofContentVersionIdwithContentDocumentIds.get(objContentVersion.Id):null;
                        lstContentDocumentLinks.add(objContentDocumentLink);
                    }
                    
                    if(lstContentDocumentLinks!=null && lstContentDocumentLinks.size()>0){
                        insert lstContentDocumentLinks;
                    }
            }
            
        }
    }

}