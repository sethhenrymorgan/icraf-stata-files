clear all
set maxvar 30000
set more off

use "C:\Users\Patnerships\Documents\spia_impact\survey_data_merge_2.dta", clear


***Geographic and Project Variables***

*binary for in the lowland areas or not
bysort village: gen ae_notmiss = _n if AEZONE != ""
bysort village: egen r1 = min(ae_notmiss)
bysort village: gen r2 = AEZONE[r1]
replace AEZONE = r2 if AEZONE == ""

g low_land = .
replace low_land =1 if AEZONE =="LM1" | AEZONE == "LM2"
replace low_land =0 if low_land==. 
lab var low_land "Lower Midland AE Zone"


***3 different project zones: KACP, FOA vi & FOA SACCO***


*assign 30 villages as KACP comparisons
replace project = 1 if village == "Billaa"
replace project = 1 if village == "Bunange"
replace project = 1 if village == "Bwake"
replace project = 1 if village == "Chebini-Soita"
replace project = 1 if village == "Chemululuchi"
replace project = 1 if village == "Kasosi"
replace project = 1 if village == "Khakula"
replace project = 1 if village == "Kibochi"
replace project = 1 if village == "Kikwechi"
replace project = 1 if village == "Kisuluni"
replace project = 1 if village == "Kituni"
replace project = 1 if village == "Lutaso A"
replace project = 1 if village == "Lutaso B"
replace project = 1 if village == "Lutaso Kabuchai"
replace project = 1 if village == "Luuya"
replace project = 1 if village == "Mabusi"
replace project = 1 if village == "Mayanja/Mungeti"
replace project = 1 if village == "Miendo"
replace project = 1 if village == "Mikayu A"
replace project = 1 if village == "Milimani"
replace project = 1 if village == "Nambaya"
replace project = 1 if village == "Namwacha"
replace project = 1 if village == "Nasianda"
replace project = 1 if village == "Samoya"
replace project = 1 if village == "Sanandiki"
replace project = 1 if village == "Sasuri"
replace project = 1 if village == "Siangwe"
replace project = 1 if village == "Sitabicha"
replace project = 1 if village == "Sitawa"
replace project = 1 if village == "Wenyila"


**16 comparison villages for Kimilili/Ndvisi aka "FOA SACCO"
replace project = 3 if village == "Bokoli Rural"
replace project = 3 if village == "Bulala"
replace project = 3 if village == "Chebukaka"
replace project = 3 if village == "Khwiroro"
replace project = 3 if village == "Lusenjule"
replace project = 3 if village == "Makunda"
replace project = 3 if village == "Manani Misikhu"
replace project = 3 if village == "Milani South B"
replace project = 3 if village == "Misikhu"
replace project = 3 if village == "Misikhu Friends"
replace project = 3 if village == "Miyekwe"
replace project = 3 if village == "Nalubito"
replace project = 3 if village == "Namilimo"
replace project = 3 if village == "Sango Sikulu"
replace project = 3 if village == "Teremi"
replace project = 3 if village == "Zayuni"


**15 Comparison villages for FOA Vi 

*8 villages for Tongaren
replace project = 2 if village == "Bunambo" 
replace project = 2 if village == "Huruma" 
replace project = 2 if village == "Kibisi B" 
replace project = 2 if village == "Mitoto A" 
replace project = 2 if village == "Nabiswa" 
replace project = 2 if village == "Nzoia" 
replace project = 2 if village == "Sinoko" 
replace project = 2 if village == "Sitabicha Tabani" 

*7 villages for Likuyani
replace project = 2 if village == "Bendera" 
replace project = 2 if village == "Majengo A" 
replace project = 2 if village == "Mulimani A" 
replace project = 2 if village == "Nzoia Ivona" 
replace project = 2 if village == "Shinyalu" 
replace project = 2 if village == "Vituyu A" 
replace project = 2 if village == "Vituyu B" 

*assign project variable to Program households
replace project = 1 if prog_area==1 & (sub_county==1 | sub_county==6)
replace project = 2 if prog_area==1 & (sub_county==4 | sub_county==9)
replace project = 3 if prog_area==1 & (sub_county==7 | sub_county==10)
replace project = 1 if village == "Bwema" & prog_area==1

label define proj_areas 1 "KACP" 2 "FOA Vi" 3 "FOA SACCO"
label values project proj_areas

gen kacp = 0
replace kacp = 1 if project == 1

gen proj_prog = .
replace proj_prog = 1 if project == 1 & prog_area == 1
replace proj_prog = 2 if (project == 2 | project == 3) & prog_area == 1

label define proj_prog 1 "KACP" 2 "FOA"
label values proj_prog proj_prog

**New information indicates that Kabula Agribiz group is a Vi group:
replace vi_group = 1 if groupid == 813



*==========*
*Covariates*
*==========*

g res_female = (gender_res==1) if gender_res !=.

g res_christ = (religion_res ==1) if religion_res !=.

g res_luhya = (ethnic_res ==1) if ethnic_res !=.

g res_married = (maritsta_res==2) if maritsta_res !=.

g res_spo_out = (maritsta_res==3) if maritsta_res !=.

g res_widow = (maritsta_res==5) if maritsta_res !=.

g res_head = (rel_res_head==1) if rel_res_head !=.

g res_spo_head = (rel_res_head==2) if rel_res_head !=.

g res_healthy = (health_res==1 | health_res==4) if health_res !=.

g res_farmer = (main_occup_res==2)

g res_busi = (main_occup_res==3)

g res_employ = (main_occup_res==6 |main_occup_res==7)

g r_tech_skill = (skills_res==1 & (skill_res_pr==2/3 | skill_res_yr<3))


*Other covariates for respondent age_res literate_res educat_res school_res official_role_res

**HH covariates 

*Add respondent to HH roster
g Oth_HH_Mem0_age_mem = age_res
g Oth_HH_Mem0_skills_mem = skills_res
g Oth_HH_Mem0_mar_stat_mem = maritsta_res
g Oth_HH_Mem0_health_mem = health_res
g Oth_HH_Mem0_occupa_mem =main_occup_res 
g Oth_HH_Mem0_rel_head_mem=rel_res_head
g Oth_HH_Mem0_gen_hh_mem = gender_res 
g Oth_HH_Mem0_sch_mem = school_res 
g Oth_HH_Mem0_lit_hh_mem = literate_res
g Oth_HH_Mem0_educat_mem = educat_res 

g head_identified = 0
forvalues i = 0/18 {
replace head_identified = 1 if Oth_HH_Mem`i'_rel_head_mem
}
lab var head_identified "Head coded for household"
tab head_identified


*number of adults
gen num_adult=0
forvalues i = 0/18 {
replace num_adult = num_adult+1 if (Oth_HH_Mem`i'_age_mem >17 & Oth_HH_Mem`i'_age_mem !=.)
}
lab var num_adult "number of adults in HH"
tab num_adult


*number of children
gen num_child=0
forvalues i = 0/18 {
replace num_child = num_child+1 if (Oth_HH_Mem`i'_age_mem <18 & Oth_HH_Mem`i'_age_mem !=.)
}
lab var num_child "number of children in HH"
tab num_child

*household size
gen hh_size = num_adult + num_child
lab var hh_size "household size" 
tab hh_size


*elderly household - no young adults in home
g not_elder_hh = 0 
forvalues i = 0/16 {
replace not_elder_hh = 1 if ((Oth_HH_Mem`i'_age_mem  > 17 & Oth_HH_Mem`i'_age_mem  <=60) & Oth_HH_Mem`i'_age_mem  !=.) 
}
recode not_elder_hh (1=0) (0=1) (.=.), gen (elder_hh)
drop not_elder_hh
la var elder_hh "all adults in HH over 59" 
tab elder_hh

*head is elderly 
g elder_headed = 0 
forvalues i = 0/16 {
replace elder_headed = 1 if (Oth_HH_Mem`i'_rel_head_mem==1 & (Oth_HH_Mem`i'_age_mem>59 & Oth_HH_Mem`i'_age_mem !=.))
}
lab var elder_headed "Head is 60 or older"
tab elder_headed


*sex of head = female 
g fem_headed = 0 
forvalues i = 0/16 {
replace fem_headed = 1 if (Oth_HH_Mem`i'_rel_head_mem==1 & Oth_HH_Mem`i'_gen_hh_mem==1) 
}
lab var fem_headed "female headed HH"
tab fem_headed

*adult in household literate
g lit_adult = 0
forvalues i = 0/16 {
replace lit_adult = 1 if (Oth_HH_Mem`i'_age_mem & Oth_HH_Mem`i'_lit_hh_mem==1)
}
lab var lit_adult "Literate adult in HH"
tab lit_adult

*female adult in household literate
g f_lit_adult = 0
forvalues i = 0/16 {
replace f_lit_adult = 1 if (Oth_HH_Mem`i'_age_mem > 17 & Oth_HH_Mem`i'_lit_hh_mem==1 & Oth_HH_Mem`i'_gen_hh_mem==1) 
}
lab var f_lit_adult "Female literate adult in HH"
tab f_lit_adult

*Head is literate 
g head_lit = 0 
forvalues i = 0/16 {
replace head_lit = 1 if (Oth_HH_Mem`i'_rel_head_mem==1 & Oth_HH_Mem`i'_lit_hh_mem==1) 
}
lab var head_lit "Head is literate"
tab head_lit

*Years of education Head 
g y_edu_head = . 
forvalues i = 0/16 {
replace y_edu_head = Oth_HH_Mem`i'_educat_mem if Oth_HH_Mem`i'_rel_head_mem==1 
}
lab var y_edu_head "Years of education head"
tab y_edu_head

*Highest level of education of adult in HH

forvalues i = 0/16 {
g y_edu_adult_`i' = Oth_HH_Mem`i'_educat_mem if (Oth_HH_Mem`i'_age_mem > 17 & Oth_HH_Mem`i'_age_mem <.)
}

egen max_edu_hh = rowmax (y_edu_adult_*) 
drop y_edu_adult_*
lab var max_edu_hh "Highest years of education of any adult in HH"
tab max_edu_hh

*Head is productive
g head_prod = 0 
forvalues i = 0/16 {
replace head_prod = 1 if Oth_HH_Mem`i'_rel_head_mem==1 & (Oth_HH_Mem`i'_occupa_mem>1 & Oth_HH_Mem`i'_occupa_mem<.) 
}
lab var head_prod "Head is productive"
tab head_prod 

*number of productive adults
forvalues i = 0/16 {
gen prod_ad_`i' = ((Oth_HH_Mem`i'_age_mem & Oth_HH_Mem`i'_age_mem !=.) & (Oth_HH_Mem`i'_occupa_mem>1 & Oth_HH_Mem`i'_occupa_mem<.)) 
}
egen num_prod_ad = rowtotal(prod_ad_*)

forvalues i = 0/16 {
drop prod_ad_`i'
}

lab var num_prod_ad "number of productive adults in HH"


*Member educated
gen mem_educated = 0
replace mem_educate = 1 if educat_res > 8
lab var mem_educate "Respondent Educated"

*member has official position
gen off_pos = 0
replace off_pos = 1 if official_role_res == 1
lab var off_pos "Official Position in Community"


***Land size at baseline
*fix outlier with decimal mistake:
replace m_par_acre_16 = m_acre_farm_16 if farmer_code == "M801"

g parcel_bl = m_par_acre_16
replace parcel_bl = m_par_acre_07 if m_par_acre_07 !=.

replace oth_par_acre_07 = 0 if oth_par_acre_07 ==.

egen land_bl = rowtotal( parcel_bl oth_par_acre_07)
lab var land_bl "Land Size at Baseline"

**Land more than one hectare
gen one_hec = 0
replace one_hec = 1 if land_bl > 2.47
lab var one_hec "Land Size at Least One Hectare"




*==================*
*Exposure Variables*
*==================*

***1. Agroforestry Group Participation***

*member of group focused on tree planting, attended at least 4-5 times & decision making to medium extent
gen grp_par_af_16 = 0
forvalues i = 1/6 {
replace grp_par_af_16 = 1 if group_par`i'_grp_type_7 == 1 & group_par`i'_grp_att >= 3 & group_par`i'_grp_att != . & group_par`i'_grp_dm >= 3 & group_par`i'_grp_dm != .
}
lab var grp_par_af_16 "Active Participation in AF Group 2016"

gen grp_par_af_07 = 0
forvalues i = 1/5 {
replace grp_par_af_07 = 1 if group_par_07`i'_grp_type_07_7 == 1 & group_par_07`i'_grp_att_07 >= 3 & group_par_07`i'_grp_att_07 != . & group_par_07`i'_grp_dm_07 >= 3 & group_par_07`i'_grp_dm_07 != .
}
lab var grp_par_af_07 "Active Participation in AF Group 2007"

***2. Receipt and Implementation of Agroforestry Training***

*received at least 1 AF training in past 3 years and implemented medium extent
gen af_train_16 = 0
replace af_train_16 = 1 if train_07_4 == 1 & train_agrof_prac >= 3 & train_agrof_prac != .
lab var af_train_16 "Recieved & Implemented Agroforestry Training 2016"

gen af_train_07 = 0
replace af_train_07 = 1 if train_07_4 == 1 & train_agrof_prac_07 >= 3 & train_agrof_prac_07 != .
lab var af_train_07 "Recieved & Implemented Agroforestry Training 2007"

***3. Receipt and Implementation of Agroforestry Extension***

*received extension support on tree planting and implemented medium extent
gen af_exten_16 = 0 
replace af_exten_16 = 1 if ext_07 == 4 & ext_agrof_prac >= 3 & ext_agrof_prac != .

gen af_exten_07 = 0
replace af_exten_07 = 1 if ext_07 == 4 & ext_agrof_prac_07 >= 3 & ext_agrof_prac != .


***4. Other agricultural support***

***Group Types***

**2016**
gen crop_grp_16 = 0
foreach i of num 1/6 {
replace crop_grp_16 = 1 if group_par`i'_grp_type_1 == 1
}
label var crop_grp_16 "crop production group"

gen dair_grp_16 = 0
foreach i of num 1/6 {
replace dair_grp_16 = 1 if group_par`i'_grp_type_2 == 1
}
label var dair_grp_16 "dairy production group"

gen poul_grp_16 = 0
foreach i of num 1/6 {
replace poul_grp_16 = 1 if group_par`i'_grp_type_3 == 1
}
label var poul_grp_16 "poultry production group"

gen oth_liv_grp_16 = 0
foreach i of num 1/6 {
replace oth_liv_grp_16 = 1 if group_par`i'_grp_type_4 == 1
}
label var oth_liv_grp_16 "other livestock group"

gen market_grp_16 = 0
foreach i of num 1/6 {
replace market_grp_16 = 1 if group_par`i'_grp_type_5 == 1
}
label var market_grp_16 "marketing of produce group"

gen soil_con_grp_16 = 0
foreach i of num 1/6 {
replace soil_con_grp_16 = 1 if group_par`i'_grp_type_6 == 1
}
label var soil_con_grp_16 "soil & water conservation group"

gen tree_grp_16 = 0
foreach i of num 1/6 {
replace tree_grp_16 = 1 if group_par`i'_grp_type_7 == 1
}
label var tree_grp_16 "tree planting & management group"

gen water_grp_16 = 0
foreach i of num 1/6 {
replace water_grp_16 = 1 if group_par`i'_grp_type_8 == 1
}
label var water_grp_16 "water use group"

gen microfi_grp_16 = 0
foreach i of num 1/6 {
replace microfi_grp_16 = 1 if group_par`i'_grp_type_9 == 1
}
label var microfi_grp_16 "microfinance group"

gen relig_grp_16 = 0
foreach i of num 1/6 {
replace relig_grp_16 = 1 if group_par`i'_grp_type_10 == 1
}
label var relig_grp_16 "religious group"

gen oth_grp_16 = 0
foreach i of num 1/6 {
replace oth_grp_16 = 1 if group_par`i'_grp_type_11 == 1
}
label var oth_grp_16 "other group"


**2007**

gen crop_grp_07 = 0
foreach i of num 1/6 {
replace crop_grp_07 = 1 if group_par`i'_grp_type_1 == 1
}
label var crop_grp_07 "crop production group"

gen dair_grp_07 = 0
foreach i of num 1/6 {
replace dair_grp_07 = 1 if group_par`i'_grp_type_2 == 1
}
label var dair_grp_07 "dairy production group"

gen poul_grp_07 = 0
foreach i of num 1/6 {
replace poul_grp_07 = 1 if group_par`i'_grp_type_3 == 1
}
label var poul_grp_07 "poultry production group"

gen oth_liv_grp_07 = 0
foreach i of num 1/6 {
replace oth_liv_grp_07 = 1 if group_par`i'_grp_type_4 == 1
}
label var oth_liv_grp_07 "other livestock group"

gen market_grp_07 = 0
foreach i of num 1/6 {
replace market_grp_07 = 1 if group_par`i'_grp_type_5 == 1
}
label var market_grp_07 "marketing of produce group"

gen soil_con_grp_07 = 0
foreach i of num 1/6 {
replace soil_con_grp_07 = 1 if group_par`i'_grp_type_6 == 1
}
label var soil_con_grp_07 "soil & water conservation group"

gen tree_grp_07 = 0
foreach i of num 1/6 {
replace tree_grp_07 = 1 if group_par`i'_grp_type_7 == 1
}
label var tree_grp_07 "tree planting & management group"

gen water_grp_07 = 0
foreach i of num 1/6 {
replace water_grp_07 = 1 if group_par`i'_grp_type_8 == 1
}
label var water_grp_07 "water use group"

gen microfi_grp_07 = 0
foreach i of num 1/6 {
replace microfi_grp_07 = 1 if group_par`i'_grp_type_9 == 1
}
label var microfi_grp_07 "microfinance group"

gen relig_grp_07 = 0
foreach i of num 1/6 {
replace relig_grp_07 = 1 if group_par`i'_grp_type_10 == 1
}
label var relig_grp_07 "religious group"

gen oth_grp_07 = 0
foreach i of num 1/6 {
replace oth_grp_07 = 1 if group_par`i'_grp_type_11 == 1
}
label var oth_grp_07 "other group"


*member of group focused on microfinance, attended at least 4-5 times & decision making to medium extent
gen grp_par_mf_16 = 0
forvalues i = 1/6 {
replace grp_par_mf_16 = 1 if microfi_grp_16 == 1 & group_par`i'_grp_att >= 3 & group_par`i'_grp_att != . & group_par`i'_grp_dm >= 3 & group_par`i'_grp_dm != .
}

gen grp_par_mf_07 = 0
forvalues i = 1/5 {
replace grp_par_mf_07 = 1 if microfi_grp_07 == 1 & group_par_07`i'_grp_att_07 >= 3 & group_par_07`i'_grp_att_07 != . & group_par_07`i'_grp_dm_07 >= 3 & group_par_07`i'_grp_dm_07 != .
}

gen grp_par_mf_all = 0
replace grp_par_mf_all = 1 if grp_par_mf_16 == 1 & grp_par_mf_07 == 1
lab var grp_par_mf_all "Active Participation in Microfinance Group"



***Types of Training***

**Past 3 years up to 2016
gen crop_trn_16 = 0
replace crop_trn_16 = 1 if train_3yrs_1 == 1
label var crop_trn_16 "crop production training"

gen dair_trn_16 = 0
replace dair_trn_16 = 1 if train_3yrs_2 == 1
label var dair_trn_16 "dairy training"

gen soil_con_trn_16 = 0
replace soil_con_trn_16 = 1 if train_3yrs_3 == 1
label var soil_con_trn_16 "soil conservation training"

gen tree_trn_16 = 0
replace tree_trn_16 = 1 if train_3yrs_4 == 1
label var tree_trn_16 "tree planting training"

gen poul_trn_16 = 0
replace poul_trn_16 = 1 if train_3yrs_5 == 1
label var poul_trn_16 "poultry training"

gen oth_liv_trn_16 = 0
replace oth_liv_trn_16 = 1 if train_3yrs_6 == 1
label var oth_liv_trn_16 "other livestock training"

gen market_trn_16 = 0
replace market_trn_16 = 1 if train_3yrs_7 == 1
label var market_trn_16 "produce marketing training"

gen proc_trn_16 = 0
replace proc_trn_16 = 1 if train_3yrs_8 == 1
label var proc_trn_16 "processing/value addition training"

gen fin_trn_16 = 0
replace fin_trn_16 = 1 if train_3yrs_9 == 1
label var fin_trn_16 "financial/microfinance training"

gen inc_gen_trn_16 = 0
replace inc_gen_trn_16 = 1 if train_3yrs_10 == 1
label var inc_gen_trn_16 "off-farm income generating activity training"


**2007**

gen crop_trn_07 = 0
replace crop_trn_07 = 1 if train_07_1 == 1
label var crop_trn_07 "crop production training"

gen dair_trn_07 = 0
replace dair_trn_07 = 1 if train_07_2 == 1
label var dair_trn_07 "dairy training"

gen soil_con_trn_07 = 0
replace soil_con_trn_07 = 1 if train_07_3 == 1
label var soil_con_trn_07 "soil conservation training"

gen tree_trn_07 = 0
replace tree_trn_07 = 1 if train_07_4 == 1
label var tree_trn_07 "tree planting training"

gen poul_trn_07 = 0
replace poul_trn_07 = 1 if train_07_5 == 1
label var poul_trn_07 "poultry training"

gen oth_liv_trn_07 = 0
replace oth_liv_trn_07 = 1 if train_07_6 == 1
label var oth_liv_trn_07 "other livestock training"

gen market_trn_07 = 0
replace market_trn_07 = 1 if train_07_7 == 1
label var market_trn_07 "produce marketing training"

gen proc_trn_07 = 0
replace proc_trn_07 = 1 if train_07_8 == 1
label var proc_trn_07 "processing/value addition training"

gen fin_trn_07 = 0
replace fin_trn_07 = 1 if train_07_9 == 1
label var fin_trn_07 "financial/microfinance training"

gen inc_gen_trn_07 = 0
replace inc_gen_trn_07 = 1 if train_07_10 == 1
label var inc_gen_trn_07 "off-farm income generating activity training"

**type of agroforestry training
label var train_agrof_typ_1 "Improved Fallows"
label var train_agrof_typ_2 "Tree Nursery Establishment"
label var train_agrof_typ_3 "Planting of trees on river banks"
label var train_agrof_typ_4 "Selection and siting of tree species"
label var train_agrof_typ_5 "Planting trees together with crops"
label var train_agrof_typ_6 "Alley planting"
label var train_agrof_typ_7 "Boundary planting"
label var train_agrof_typ_8 "Woodlot establishment"
label var train_agrof_typ_9 "Home or tree gardents"
label var train_agrof_typ_10 "Contour tree planting"
label var train_agrof_typ_11 "Trees with perennial crops"
label var train_agrof_typ_12 "Farmer Managed Natural Regeneration"
label var train_agrof_typ_13 "Enrichment planting"
label var train_agrof_typ_14 "Fodder trees"
label var train_agrof_typ_15 "Fodder shrub banks"
label var train_agrof_typ_16 "Tree orchard establishment"
label var train_agrof_typ_17 "Other tree planting training"



*============================*
*Uptake of Promoted Practices*
*============================*

**Fixing plot size outliers:
*replacing with median:
replace plot1_plot_acre = 0.5 if farmer_code == "W1044"

*adding in decimal so adds up to parcel size:
replace plot2_plot_acre = 0.125 if farmer_code == "W1507"


*===========================*
*1. Agroforestry Adoption Index

***AF Adoption Indicators 2016***

*Identify which plot is the largest
gen which_max = ""
gen max = 0

global acres "plot1_plot_acre plot2_plot_acre plot3_plot_acre plot4_plot_acre plot5_plot_acre plot6_plot_acre plot7_plot_acre plot8_plot_acre plot9_plot_acre plot10_plot_acre"

foreach x of global acres {
replace which_max = "`x'" if `x' > max & `x' != .
replace max = `x' if `x' > max & `x' != .
}

foreach i of num 1/10 {
	gen plot`i'_fd_crop_16 = 0
	foreach j of num 1/20 {
	replace plot`i'_fd_crop_16 = 1 if plot`i'_plot_crop_list_16_`j' == 1
	}
}
foreach i of num 1/10 {
	gen plot`i'_plnt_crop_16 = 0
	foreach j of num 21/25 {
	replace plot`i'_plnt_crop_16 = 1 if plot`i'_plot_crop_list_16_`j' == 1
	}
}
foreach i of num 1/10 {
	gen plot`i'_hort_crop_16 = 0
	foreach j of num 26/43 {
	replace plot`i'_hort_crop_16 = 1 if plot`i'_plot_crop_list_16_`j' == 1
	}
}




*designate main food plot:
*largest plot which is not used for sugar cane, coffee, tea, or cotton
gen main_food_plot_16 = 0
replace main_food_plot_16 = 1 if which_max == "plot1_plot_acre" & plot1_fd_crop_16 == 1 | plot1_hort_crop_16 == 1
replace main_food_plot_16 = 2 if which_max == "plot2_plot_acre" & plot2_fd_crop_16 == 1 | plot2_hort_crop_16 == 1
replace main_food_plot_16 = 3 if which_max == "plot3_plot_acre" & plot3_fd_crop_16 == 1 | plot3_hort_crop_16 == 1
replace main_food_plot_16 = 4 if which_max == "plot4_plot_acre" & plot4_fd_crop_16 == 1 | plot4_hort_crop_16 == 1
replace main_food_plot_16 = 5 if which_max == "plot5_plot_acre" & plot5_fd_crop_16 == 1 | plot5_hort_crop_16 == 1
replace main_food_plot_16 = 6 if which_max == "plot6_plot_acre" & plot6_fd_crop_16 == 1 | plot6_hort_crop_16 == 1
replace main_food_plot_16 = 7 if which_max == "plot7_plot_acre" & plot7_fd_crop_16 == 1 | plot7_hort_crop_16 == 1
replace main_food_plot_16 = 9 if which_max == "plot9_plot_acre" & plot9_fd_crop_16 == 1 | plot9_hort_crop_16 == 1

gen which_2nd = ""
gen val_2nd = 0
foreach x of global acres {
replace which_2nd = "`x'" if `x' > val_2nd & `x' <= max & `x' != . & "`x'" != which_max
replace val_2nd = `x' if `x' > val_2nd & `x' <= max & `x' != . & "`x'" != which_max
}

*for those values where the largest plot was used for sugar cane, coffee, tea, or cotton, 
*designate 2nd largest as main food plot
replace main_food_plot_16 = 1 if main_food_plot_16 == 0 & which_2nd == "plot1_plot_acre" & (plot1_fd_crop_16 == 1 | plot1_hort_crop_16 == 1)
replace main_food_plot_16 = 2 if main_food_plot_16 == 0 & which_2nd == "plot2_plot_acre" & (plot2_fd_crop_16 == 1 | plot2_hort_crop_16 == 1)
replace main_food_plot_16 = 3 if main_food_plot_16 == 0 & which_2nd == "plot3_plot_acre" & (plot3_fd_crop_16 == 1 | plot3_hort_crop_16 == 1)
replace main_food_plot_16 = 4 if main_food_plot_16 == 0 & which_2nd == "plot4_plot_acre" & (plot4_fd_crop_16 == 1 | plot4_hort_crop_16 == 1)
replace main_food_plot_16 = 5 if main_food_plot_16 == 0 & which_2nd == "plot5_plot_acre" & (plot5_fd_crop_16 == 1 | plot5_hort_crop_16 == 1)
replace main_food_plot_16 = 6 if main_food_plot_16 == 0 & which_2nd == "plot6_plot_acre" & (plot6_fd_crop_16 == 1 | plot6_hort_crop_16 == 1)
replace main_food_plot_16 = 7 if main_food_plot_16 == 0 & which_2nd == "plot7_plot_acre" & (plot7_fd_crop_16 == 1 | plot7_hort_crop_16 == 1)

gen which_3rd = ""
gen val_3rd = 0
foreach x of global acres {
replace which_3rd = "`x'" if `x' > val_3rd & `x' <= val_2nd & `x' !=. & "`x'" != which_max & "`x'" != which_2nd
replace val_3rd = `x' if `x' > val_3rd & `x' <= val_2nd & `x' !=. & "`x'" != which_max & "`x'" != which_2nd
}

replace main_food_plot_16 = 1 if main_food_plot_16 == 0 & which_3rd == "plot1_plot_acre" & (plot1_fd_crop_16 == 1 | plot1_hort_crop_16 == 1)
replace main_food_plot_16 = 2 if main_food_plot_16 == 0 & which_3rd == "plot2_plot_acre" & (plot2_fd_crop_16 == 1 | plot2_hort_crop_16 == 1)
replace main_food_plot_16 = 3 if main_food_plot_16 == 0 & which_3rd == "plot3_plot_acre" & (plot3_fd_crop_16 == 1 | plot3_hort_crop_16 == 1)
replace main_food_plot_16 = 4 if main_food_plot_16 == 0 & which_3rd == "plot4_plot_acre" & (plot4_fd_crop_16 == 1 | plot4_hort_crop_16 == 1)
replace main_food_plot_16 = 5 if main_food_plot_16 == 0 & which_3rd == "plot5_plot_acre" & (plot5_fd_crop_16 == 1 | plot5_hort_crop_16 == 1)
replace main_food_plot_16 = 6 if main_food_plot_16 == 0 & which_3rd == "plot6_plot_acre" & (plot6_fd_crop_16 == 1 | plot6_hort_crop_16 == 1)

*39 observations left at 0, report no food crop plots



***Indicator 1.1 2 or more tree products from main plot***

foreach i of num 1/8 {
gen plot`i'_firewd_16 = 1 if plot`i'_plot_tr_pro_t_16_1 == 1 | plot`i'_plot_tr_pro_t_16_2 == 1
gen plot`i'_timber_16 = 1 if plot`i'_plot_tr_pro_t_16_3 == 1 | plot`i'_plot_tr_pro_t_16_4 == 1
gen plot`i'_fruit_16 = 1 if plot`i'_plot_tr_pro_t_16_5 == 1 | plot`i'_plot_tr_pro_t_16_6 == 1
gen plot`i'_fodd_16 = 1 if plot`i'_plot_tr_pro_t_16_7 == 1 | plot`i'_plot_tr_pro_t_16_8 == 1
gen plot`i'_med_16 = 1 if plot`i'_plot_tr_pro_t_16_9 == 1 | plot`i'_plot_tr_pro_t_16_11 == 1
gen plot`i'_grman_16 = 1 if plot`i'_plot_tr_pro_t_16_13 == 1
gen plot`i'_oth_16 = 1 if plot`i'_plot_tr_pro_t_16_12 == 1
}

foreach i of num 1/8 {
egen plot`i'_pro_t_16 = rowtotal(plot`i'_firewd_16 plot`i'_timber_16 plot`i'_fruit_16 plot`i'_fodd_16 plot`i'_med_16 plot`i'_grman_16 plot`i'_oth_16)
}

gen mn_plot_pro_16 = 0
replace mn_plot_pro_16 = 1 if (plot1_pro_t_16 >= 2 & main_food_plot_16 == 1) | (plot2_pro_t_16 >= 2 & main_food_plot_16 == 2) | (plot3_pro_t_16 >= 2 & main_food_plot_16 == 3) | (plot4_pro_t_16 >= 2 & main_food_plot_16 == 4) | (plot5_pro_t_16 >= 2 & main_food_plot_16 == 5) | (plot6_pro_t_16 >= 2 & main_food_plot_16 == 6) | (plot7_pro_t_16 >= 2 & main_food_plot_16 == 7) | (plot8_pro_t_16 >= 2 & main_food_plot_16 == 8)
label var mn_plot_pro_16 "2 or More Tree Products from Main Food Plot"

***Indicator 1.2: Tree Based NRM within main food plot***

gen tree_nrm_16 = 0 
label var tree_nrm_16 "Tree-Based Natural Resource Management"
foreach i of num 1/10 {
	replace tree_nrm_16 = 1 if plot`i'_plot_prac_16_3 == 1
	foreach j of num 2 3 4 6 {
	replace tree_nrm_16 = 1 if plot`i'_plot_tr_arg_16_`j' == 1
	replace tree_nrm_16 = 1 if oth_tr_arg_16_`j' == 1
	}
}

foreach i of num 2/5 {
replace tree_nrm_16 = 1 if plot`i'_plot_i_fal_n_16 > 0 & plot`i'_plot_i_fal_n_16 != .
}

***Indicator 1.3: Complementary Agroforestry Practices***

gen woodlot_16 = 0
foreach i of num 1/10 {
replace woodlot_16 = 1 if plot`i'_plot_use_s_16 == 3
}
replace woodlot_16 = 1 if oth_w_lot_16 == 1


gen orchard_16 = 0
foreach i of num 1/10 {
replace orchard_16 = 1 if plot`i'_plot_use_s_16 == 2
}
replace orchard_16 = 1 if ft_hstead_n > 10 & ft_hstead_n != .
*max of ft_hstead_n is 6
replace orchard_16 = 1 if oth_orc_16 == 1

gen fod_bank_16 = 0
foreach i of num 1/10 {
replace fod_bank_16 = 1 if plot`i'_plot_use_s_16 == 7
}
replace fod_bank_16 = 1 if fod_hstead_n > 3 & fod_hstead_n != .
*max of fod_hstead_n is 6
replace fod_bank_16 = 1 if oth_fb_16 == 1

foreach i of num 1/10 {
gen plot`i'_fod_shrub_16 = 0
	foreach j of num 5 14 15 {
	replace plot`i'_fod_shrub_16 = 1 if plot`i'_plot_tr_spe_16_`j' == 1
	}
}

foreach i of num 1/8 {
replace fod_bank_16 = 1 if plot`i'_fod_shrub_16 == 1 & plot`i'_fodd_16 == 1
}

gen i_fal_16 = 0
foreach i of num 1/10 {
replace i_fal_16 = 1 if plot`i'_plot_use_s_16 == 10
}

egen n_com_prac_16 = rowtotal(woodlot_16 orchard_16 fod_bank_16 i_fal_16)
gen com_prac_16 = 0
replace com_prac_16 = 1 if n_com_prac_16 >= 1 & n_com_prac_16 != .
*only 117, 4% of the sample, get a 1 on this
label var com_prac_16 "Complementary Practices"


***Indicator 2.1 Farm Plot Tree Density***

foreach i of num 1/10 {
gen plot`i'exist = 1 if plot`i'_plot_acre > 0 & plot`i'_plot_acre !=.
}
egen numplots = rowtotal(plot1exist plot2exist plot3exist plot4exist plot5exist plot6exist plot7exist plot8exist plot9exist plot10exist)

egen numplots_tr = rowtotal(plot1_plot_tr_16 plot2_plot_tr_16 plot3_plot_tr_16 plot4_plot_tr_16 plot5_plot_tr_16 plot6_plot_tr_16 plot7_plot_tr_16 plot8_plot_tr_16 plot9_plot_tr_16 plot10_plot_tr_16)

*at least 50 trees on plot
foreach i of num 1/10 {
gen plot`i'_tr_50_16 = 1 if plot`i'_plot_tr_16 == 1 & plot`i'_plot_tr_n_16 >= 5
}

*at least 20 trees on plot
foreach i of num 1/10 {
gen plot`i'_tr_20_16 = 1 if plot`i'_plot_tr_16 == 1 & plot`i'_plot_tr_n_16 >= 4
}

*at least one plot with more than 50 trees
gen plot_any_tr_50_16 = 0
foreach i of num 1/10 {
replace plot_any_tr_50_16 = 1 if plot`i'_tr_50_16 == 1
}

*all plots with at least 20 trees
egen numplots_tr_20 = rowtotal(plot1_tr_20_16 plot2_tr_20_16 plot3_tr_20_16 plot4_tr_20_16 plot5_tr_20_16 plot6_tr_20_16 plot7_tr_20_16 plot8_tr_20_16 plot9_tr_20_16 plot10_tr_20_16)

gen all_tr_20_16 = 0
replace all_tr_20_16 = 1 if numplots == numplots_tr_20

*Binary indicator for tree density: all plots have more than 20 trees, at least one more than 50
gen tree_density_bin_16 = 0
replace tree_density_bin_16 = 1 if plot_any_tr_50_16 == 1 & all_tr_20_16 == 1
label var tree_density_bin_16 "50 trees on one plot, 20 on all others"

*Alternate indicator: 1 plot with 50 trees or all plots with at least 20

gen tree_dens_alt_16 = 0
replace tree_dens_alt_16 = 1 if plot_any_tr_50_16 == 1
replace tree_dens_alt_16 = 1 if all_tr_20_16 == 1 & numplots > 1
label var tree_dens_alt_16 "50 trees on one plot or 20 on all"



***Indicator 2.2 Farm Plot Tree Product Sales***

*at least one tree product from farm plot produced for sale:
gen tr_pro_sale_16 = 0
label var tr_pro_sale_16 "Tree Products from Farm Plots for Sale"
foreach i of num 1/8{
	foreach j of num 2 4 6 8 11 {
	replace tr_pro_sale_16 = 1 if plot`i'_plot_tr_pro_t_16_`j' == 1 & plot`i'_plot_use_s_16 == 1 
	}
}
*products from other farm plots
foreach i of num 2 4 6 8 11 {
replace tr_pro_sale_16 = 1 if oth_tr_pro_t_16_`i' == 1
}

***Indicator 2.3 Intensity of Complementary Practices***

*variable for orchard with over 10 trees, or orchard in other parcel
gen orchard_hi_16 = 0
foreach i of num 1/10 {
replace orchard_hi_16 = 1 if plot`i'_plot_use_s_16 == 2 & plot`i'_plot_tr_n_16 >= 3 & plot`i'_plot_tr_n_16 != . 
}
replace orchard_hi_16 = 1 if oth_orc_16 == 1 

*variable for wood lot with over 100 trees
gen woodlot_hi_16 = 0
foreach i of num 1/10 {
replace woodlot_hi_16 = 1 if plot`i'_plot_use_s_16 == 3 & plot`i'_plot_tr_n_16 >= 5 & plot`i'_plot_tr_n_16 != . 
}
replace woodlot_hi_16 = 1 if oth_w_lot_16 == 1

*variable for tree based fodder bank with over 50 shrubs
gen fod_bank_hi_16 = 0
foreach i of num 1/10 {
replace fod_bank_hi_16 = 1 if plot`i'_plot_use_s_16 == 7 & plot`i'_plot_tr_n_16 >= 5 & plot`i'_plot_tr_n_16 != .
}

replace fod_bank_hi = 1 if oth_fb_16 == 1

foreach i of num 1/8 {
replace fod_bank_hi_16 = 1 if plot`i'_fod_shrub == 1 & plot`i'_fodd == 1 & plot`i'_plot_tr_n_16 >= 5 & plot`i'_plot_tr_n_16 != .
}

gen comp_prac_int_16 = 0
replace comp_prac_int_16 = 1 if orchard_hi == 1 | woodlot_hi == 1 | fod_bank_hi == 1
label var comp_prac_int_16 "Intensity of Complementary Practices"


***Indicator 2.4 Sales from Complementary Practices***

*products for sale from complementary practices on non-farming plots
gen comp_prac_sale_16 = 0
label var comp_prac_sale_16 "Products for Sale from Complementary Practices"
foreach i of num 1/8{
	foreach j of num 2 4 6 8 11 {
		foreach k of num 2 3 7 10 {
		replace comp_prac_sale_16 = 1 if plot`i'_plot_tr_pro_t_16_`j' == 1 & plot`i'_plot_use_s_16 == `k'
		}
	}
}

*tree products from orchards
foreach i of num 1/6 {
	foreach j of num 2 4 6 8 11 {
	replace comp_prac_sale_16 = 1 if plot`i'_plot_fr_pro_16_`j' == 1
	}
}

*tree products from woodlots
foreach i of num 1/6 8 10 {
	foreach j of num 2 4 6 8 11 {
	replace comp_prac_sale_16 = 1 if plot`i'_plot_wl_pro_16_`j' == 1
	}
}

*tree products from fodder banks
foreach i of num 1/3 {
	foreach j of num 2 4 6 8 11 {
	replace comp_prac_sale_16 = 1 if plot`i'_plot_fod_pro_16_`j' == 1
	}
}

*tree products from improved fallows
foreach i of num 2/4 {
	foreach j of num 2 4 6 8 11 {
	replace comp_prac_sale_16 = 1 if plot`i'_plot_i_fal_pro_16_`j' == 1
	}
}

*products from other orchards
foreach i of num 2 4 6 8 11 {
replace comp_prac_sale_16 = 1 if oth_orc_16 == 1 & oth_orc_pro_t_16_`i' == 1
}
*products from other woodlots
foreach i of num 2 4 6 8 11 {
replace comp_prac_sale_16 = 1 if oth_w_lot_16 == 1 & oth_w_lot_pro_t_16_`i' == 1
}
*no products reported from other fodder banks



***Indicator 3.1 Leguminous Shrubs***

gen legume_shrub_16 = 0
label var legume_shrub_16 "Introduced Leguminous Shrubs"
*legume shrubs in farm plots
foreach i of num 1/10 {
	foreach j of num 5 14 15 {
	replace legume_shrub_16 = 1 if plot`i'_plot_tr_spe_16_`j' == 1
	}
}

*legume shrubs in woodlots
foreach i of num 1/8 10 {
	foreach j of num 5 14 15 {
	replace legume_shrub_16 = 1 if plot`i'_plot_wl_sp_16_`j' == 1
	}
}

*legume shrubs in orchards
foreach i of num 1/6 {
	foreach j of num 5 14 15 {
	replace legume_shrub_16 = 1 if plot`i'_plot_fr_sp_16_`j' == 1
	}
}

*legume shrubs in fodder banks
foreach i of num 1/3 {
	foreach j of num 5 14 15 {
	replace legume_shrub_16 = 1 if plot`i'_plot_fod_sp_16_`j' == 1
	}
}

*legume shrubs in improved fallows
foreach i of num 2/5{ 
	foreach j of num 5 14 15 {
	replace legume_shrub_16 = 1 if plot`i'_plot_i_fal_sp_16_`j' == 1
	}
}

*legume shrubs in other farm plots
foreach i of num 5 14 15 {
replace legume_shrub_16 = 1 if oth_tr_spe_16_`i' == 1
}

*legume shrubs in other orchards
foreach i of num 5 14 15 {
replace legume_shrub_16 = 1 if oth_w_lot_s_t_16_`i' == 1
}

*legume shrubs in other woodlots
foreach i of num 5 14 15 {
replace legume_shrub_16 = 1 if oth_orc_s_t_16_`i' == 1
}


*legume shrubs in other fodder banks
foreach i of num 5 14 15 {
replace legume_shrub_16 = 1 if oth_fb_s_t_16_`i' == 1
}


***Indicator 3.2 Presence of at least 3 long-term exotics promoted by Vi***

*Annona spp
unab annona : plot*tr_spe_16_3 
egen annon_np_16 = rowtotal(`annona' oth_tr_spe_16_3 oth_w_lot_s_t_16_3 oth_orc_s_t_16_3 oth_fb_s_t_16_3 oth_w_lot_s_t_16_3 oth_fb_s_t_16_3) 
gen annon_yn_16 = 0
replace annon_yn_16 = 1 if annon_np_16 > 0 & annon_np_16 != .

*casuarina
unab casua : plot*tr_spe_16_8
egen casua_np_16 = rowtotal(`casua' oth_tr_spe_16_8 oth_w_lot_s_t_16_8 oth_orc_s_t_16_8 oth_fb_s_t_16_8 oth_w_lot_s_t_16_8 oth_fb_s_t_16_8) 
gen casua_yn_16 = 0
replace casua_yn_16 = 1 if casua_np_16 > 0 & casua_np_16 != .

*Grevillea
unab grevi : plot*tr_spe_16_13
egen grevi_np_16 = rowtotal(`grevi' oth_tr_spe_16_13 oth_w_lot_s_t_16_13 oth_orc_s_t_16_13 oth_fb_s_t_16_13 oth_w_lot_s_t_16_13 oth_fb_s_t_16_13) 
gen grevi_yn_16 = 0
replace grevi_yn_16 = 1 if grevi_np_16 > 0 & grevi_np_16 != .

*Persea americana (avocado)
unab avoca : plot*tr_spe_16_33
egen avoca_np_16 = rowtotal(`avoca' oth_tr_spe_16_33 oth_w_lot_s_t_16_33 oth_orc_s_t_16_33 oth_fb_s_t_16_33 oth_w_lot_s_t_16_33 oth_fb_s_t_16_33) 
gen avoca_yn_16 = 0
replace avoca_yn_16 = 1 if avoca_np_16 > 0 & avoca_np_16 != .

*Syzigium
unab syzig : plot*tr_spe_16_37
egen syzig_np_16 = rowtotal(`syzig' oth_tr_spe_16_37 oth_w_lot_s_t_16_37 oth_orc_s_t_16_37 oth_fb_s_t_16_37 oth_w_lot_s_t_16_37 oth_fb_s_t_16_37) 
gen syzig_yn_16 = 0
replace syzig_yn_16 = 1 if syzig_np_16 > 0 & syzig_np_16 != .

*Casimiroa edulis
unab casim : plot*tr_spe_16_40
egen casim_np_16 = rowtotal(`casim' oth_tr_spe_16_40 oth_w_lot_s_t_16_40 oth_orc_s_t_16_40 oth_fb_s_t_16_40 oth_w_lot_s_t_16_40 oth_fb_s_t_16_40) 
gen casim_yn_16 = 0
replace casim_yn_16 = 1 if casim_np_16 > 0 & casim_np_16 != .

*number of exotic tree species anywhere on farm
egen spe_exo_n_16 = rowtotal(annon_yn_16 casua_yn_16 grevi_yn_16 avoca_yn_16 syzig_yn_16 casim_yn_16)

gen long_spe_exo_16 = 0
replace long_spe_exo_16 = 1 if spe_exo_n_16 >= 3 & spe_exo_n_16 != .
label var long_spe_exo_16 "Promoted Exotic Species"


***Indicator 3.3 Long-term Natives Promoted by Vi***

*Cordia africana
unab cordia: plot*tr_spe_16_11
egen cordia_np_16 = rowtotal(`cordia' oth_tr_spe_16_11 oth_w_lot_s_t_16_11 oth_orc_s_t_16_11 oth_fb_s_t_16_11 oth_w_lot_s_t_16_11 oth_fb_s_t_16_11) 
gen cordia_yn_16 = 0
replace cordia_yn_16 = 1 if cordia_np_16 > 0 & cordia_np_16 != .

*Markhamia lutea
unab markh: plot*tr_spe_16_26
egen markh_np_16 = rowtotal(`markh' oth_tr_spe_16_26 oth_w_lot_s_t_16_26 oth_orc_s_t_16_26 oth_fb_s_t_16_26 oth_w_lot_s_t_16_26 oth_fb_s_t_16_26) 
gen markh_yn_16 = 0
replace markh_yn_16 = 1 if markh_np_16 > 0 & markh_np_16 != .

*Croton megalocarpus
unab crmeg: plot*tr_spe_16_16
egen crmeg_np_16 = rowtotal(`crmeg' oth_tr_spe_16_16 oth_w_lot_s_t_16_16 oth_orc_s_t_16_16 oth_fb_s_t_16_16 oth_w_lot_s_t_16_16 oth_fb_s_t_16_16) 
gen crmeg_yn_16 = 0
replace crmeg_yn_16 = 1 if crmeg_np_16 > 0 & crmeg_np_16 != .

*Croton macrostachus
unab crmac: plot*tr_spe_16_12
egen crmac_np_16 = rowtotal(`crmac' oth_tr_spe_16_12 oth_w_lot_s_t_16_12 oth_orc_s_t_16_12 oth_fb_s_t_16_12 oth_w_lot_s_t_16_12 oth_fb_s_t_16_12) 
gen crmac_yn_16 = 0
replace crmac_yn_16 = 1 if crmac_np_16 > 0 & crmac_np_16 != .

*Prunus africana
unab prunu: plot*tr_spe_16_35
egen prunu_np_16 = rowtotal(`prunu' oth_tr_spe_16_35 oth_w_lot_s_t_16_35 oth_orc_s_t_16_35 oth_fb_s_t_16_35 oth_w_lot_s_t_16_35 oth_fb_s_t_16_35) 
gen prunu_yn_16 = 0
replace prunu_yn_16 = 1 if prunu_np_16 > 0 & prunu_np_16 != .

*Olea capensis
unab olcap: plot*tr_spe_16_32
egen olcap_np_16 = rowtotal(`olcap' oth_tr_spe_16_32 oth_w_lot_s_t_16_32 oth_orc_s_t_16_32 oth_fb_s_t_16_32 oth_w_lot_s_t_16_32 oth_fb_s_t_16_32) 
gen olcap_yn_16 = 0
replace olcap_yn_16 = 1 if olcap_np_16 > 0 & olcap_np_16 != .

*Vitex keniensis
unab vitex: plot*tr_spe_16_38
egen vitex_np_16 = rowtotal(`vitex' oth_tr_spe_16_38 oth_w_lot_s_t_16_38 oth_orc_s_t_16_38 oth_fb_s_t_16_38 oth_w_lot_s_t_16_38 oth_fb_s_t_16_38) 
gen vitex_yn_16 = 0
replace vitex_yn_16 = 1 if vitex_np_16 > 0 & vitex_np_16 != .

*Podocarpus falcatus
unab podoc: plot*tr_spe_16_34
egen podoc_np_16 = rowtotal(`podoc' oth_tr_spe_16_34 oth_w_lot_s_t_16_34 oth_orc_s_t_16_34 oth_fb_s_t_16_34 oth_w_lot_s_t_16_34 oth_fb_s_t_16_34) 
gen podoc_yn_16 = 0
replace podoc_yn_16 = 1 if podoc_np_16 > 0 & podoc_np_16 != .

*number of native tree species anywhere on farm
egen spe_nat_n_16 = rowtotal(cordia_yn_16 markh_yn_16 crmeg_yn_16 crmac_yn_16 prunu_yn_16 olcap_yn_16 vitex_yn_16 podoc_yn_16)

gen long_spe_nat_16 = 0
replace long_spe_nat_16 = 1 if spe_nat_n_16 >= 3 & spe_nat_n_16 != .
label var long_spe_nat_16 "Promoted Native Species"


***AF Adoption Indicators 2007***

foreach i of num 1/10 {
	gen plot`i'_fd_crop_07 = 0
	foreach j of num 1/20 {
	replace plot`i'_fd_crop_07 = 1 if plot`i'_plot_crop_list_07_`j' == 1
	}
}
foreach i of num 1/10 {
	gen plot`i'_plnt_crop_07 = 0
	foreach j of num 21/25 {
	replace plot`i'_plnt_crop_07 = 1 if plot`i'_plot_crop_list_07_`j' == 1
	}
}
foreach i of num 1/10 {
	gen plot`i'_hort_crop_07 = 0
	foreach j of num 26/43 {
	replace plot`i'_hort_crop_07 = 1 if plot`i'_plot_crop_list_07_`j' == 1
	}
}


*designate main food plot:
*largest plot which is not used for sugar cane, coffee, tea, or cotton
gen main_food_plot_07 = 0
replace main_food_plot_07 = 1 if which_max == "plot1_plot_acre" & plot1_fd_crop_07 == 1 | plot1_hort_crop_07 == 1
replace main_food_plot_07 = 2 if which_max == "plot2_plot_acre" & plot2_fd_crop_07 == 1 | plot2_hort_crop_07 == 1
replace main_food_plot_07 = 3 if which_max == "plot3_plot_acre" & plot3_fd_crop_07 == 1 | plot3_hort_crop_07 == 1
replace main_food_plot_07 = 4 if which_max == "plot4_plot_acre" & plot4_fd_crop_07 == 1 | plot4_hort_crop_07 == 1
replace main_food_plot_07 = 5 if which_max == "plot5_plot_acre" & plot5_fd_crop_07 == 1 | plot5_hort_crop_07 == 1
replace main_food_plot_07 = 6 if which_max == "plot6_plot_acre" & plot6_fd_crop_07 == 1 | plot6_hort_crop_07 == 1
replace main_food_plot_07 = 7 if which_max == "plot7_plot_acre" & plot7_fd_crop_07 == 1 | plot7_hort_crop_07 == 1
replace main_food_plot_07 = 9 if which_max == "plot9_plot_acre" & plot9_fd_crop_07 == 1 | plot9_hort_crop_07 == 1


*for those values where the largest plot was used for sugar cane, coffee, tea, or cotton, 
*designate 2nd largest as main food plot
replace main_food_plot_07 = 1 if main_food_plot_07 == 0 & which_2nd == "plot1_plot_acre" & (plot1_fd_crop_07 == 1 | plot1_hort_crop_07 == 1)
replace main_food_plot_07 = 2 if main_food_plot_07 == 0 & which_2nd == "plot2_plot_acre" & (plot2_fd_crop_07 == 1 | plot2_hort_crop_07 == 1)
replace main_food_plot_07 = 3 if main_food_plot_07 == 0 & which_2nd == "plot3_plot_acre" & (plot3_fd_crop_07 == 1 | plot3_hort_crop_07 == 1)
replace main_food_plot_07 = 4 if main_food_plot_07 == 0 & which_2nd == "plot4_plot_acre" & (plot4_fd_crop_07 == 1 | plot4_hort_crop_07 == 1)
replace main_food_plot_07 = 5 if main_food_plot_07 == 0 & which_2nd == "plot5_plot_acre" & (plot5_fd_crop_07 == 1 | plot5_hort_crop_07 == 1)
replace main_food_plot_07 = 6 if main_food_plot_07 == 0 & which_2nd == "plot6_plot_acre" & (plot6_fd_crop_07 == 1 | plot6_hort_crop_07 == 1)
replace main_food_plot_07 = 7 if main_food_plot_07 == 0 & which_2nd == "plot7_plot_acre" & (plot7_fd_crop_07 == 1 | plot7_hort_crop_07 == 1)
replace main_food_plot_07 = 8 if main_food_plot_07 == 0 & which_2nd == "plot8_plot_acre" & (plot8_fd_crop_07 == 1 | plot8_hort_crop_07 == 1)


replace main_food_plot_07 = 1 if main_food_plot_07 == 0 & which_3rd == "plot1_plot_acre" & (plot1_fd_crop_07 == 1 | plot1_hort_crop_07 == 1)
replace main_food_plot_07 = 2 if main_food_plot_07 == 0 & which_3rd == "plot2_plot_acre" & (plot2_fd_crop_07 == 1 | plot2_hort_crop_07 == 1)
replace main_food_plot_07 = 3 if main_food_plot_07 == 0 & which_3rd == "plot3_plot_acre" & (plot3_fd_crop_07 == 1 | plot3_hort_crop_07 == 1)
replace main_food_plot_07 = 4 if main_food_plot_07 == 0 & which_3rd == "plot4_plot_acre" & (plot4_fd_crop_07 == 1 | plot4_hort_crop_07 == 1)
replace main_food_plot_07 = 5 if main_food_plot_07 == 0 & which_3rd == "plot5_plot_acre" & (plot5_fd_crop_07 == 1 | plot5_hort_crop_07 == 1)
replace main_food_plot_07 = 6 if main_food_plot_07 == 0 & which_3rd == "plot6_plot_acre" & (plot6_fd_crop_07 == 1 | plot6_hort_crop_07 == 1)
replace main_food_plot_07 = 7 if main_food_plot_07 == 0 & which_3rd == "plot7_plot_acre" & (plot7_fd_crop_07 == 1 | plot7_hort_crop_07 == 1)

replace main_food_plot_07 = main_food_plot_16 if main_food_plot_07 == 0


***Indicator 1.1 2 or more tree products from main plot***

foreach i of num 1/8 {
gen plot`i'_firewd_07 = 1 if plot`i'_plot_tr_pro_t_07_1 == 1 | plot`i'_plot_tr_pro_t_07_2 == 1
gen plot`i'_timber_07 = 1 if plot`i'_plot_tr_pro_t_07_3 == 1 | plot`i'_plot_tr_pro_t_07_4 == 1
gen plot`i'_fruit_07 = 1 if plot`i'_plot_tr_pro_t_07_5 == 1 | plot`i'_plot_tr_pro_t_07_6 == 1
gen plot`i'_fodd_07 = 1 if plot`i'_plot_tr_pro_t_07_7 == 1 | plot`i'_plot_tr_pro_t_07_8 == 1
gen plot`i'_med_07 = 1 if plot`i'_plot_tr_pro_t_07_9 == 1 | plot`i'_plot_tr_pro_t_07_11 == 1
gen plot`i'_grman_07 = 1 if plot`i'_plot_tr_pro_t_07_13 == 1
gen plot`i'_oth_07 = 1 if plot`i'_plot_tr_pro_t_07_12 == 1
}

foreach i of num 1/8 {
egen plot`i'_pro_t_07 = rowtotal(plot`i'_firewd_07 plot`i'_timber_07 plot`i'_fruit_07 plot`i'_fodd_07 plot`i'_med_07 plot`i'_grman_07 plot`i'_oth_07)
}

gen mn_plot_pro_07 = 0
replace mn_plot_pro_07 = 1 if (plot1_pro_t_07 >= 2 & main_food_plot_07 == 1) | (plot2_pro_t_07 >= 2 & main_food_plot_07 == 2) | (plot3_pro_t_07 >= 2 & main_food_plot_07 == 3) | (plot4_pro_t_07 >= 2 & main_food_plot_07 == 4) | (plot5_pro_t_07 >= 2 & main_food_plot_07 == 5) | (plot6_pro_t_07 >= 2 & main_food_plot_07 == 6) | (plot7_pro_t_07 >= 2 & main_food_plot_07 == 7) | (plot8_pro_t_07 >= 2 & main_food_plot_07 == 8)
label var mn_plot_pro_07 "2 or More Tree Products from Main Plot"

***Indicator 1.2: Tree Based NRM within main food plot***

gen tree_nrm_07 = 0 
label var tree_nrm_07 "Tree-based Natural Resource Management"
foreach i of num 1/10 {
replace tree_nrm_07 = 1 if plot`i'_plot_prac_07_3 == 1
}

foreach i of num 1/8 {
	foreach j of num 2 3 4 6 {
	replace tree_nrm_07 = 1 if plot`i'_plot_tr_arg_07_`j' == 1
	replace tree_nrm_07 = 1 if oth_tr_arg_07_`j' == 1
	}
}

foreach i of num 1 2 3 5 {
replace tree_nrm_07 = 1 if plot`i'_plot_i_fal_n_07 > 0 & plot`i'_plot_i_fal_n_07 != .
}

***Indicator 1.3: Complementary Agroforestry Practices***

gen woodlot_07 = 0
foreach i of num 1/10 {
replace woodlot_07 = 1 if plot`i'_plot_use_s_07 == 3
}
replace woodlot_07 = 1 if oth_w_lot_07 == 1


gen orchard_07 = 0
foreach i of num 1/10 {
replace orchard_07 = 1 if plot`i'_plot_use_s_07 == 2
}
replace orchard_07 = 1 if ft_hstead_n > 10 & ft_hstead_n != .
*max of ft_hstead_n is 6
replace orchard_07 = 1 if oth_orc_07 == 1

gen fod_bank_07 = 0
foreach i of num 1/10 {
replace fod_bank_07 = 1 if plot`i'_plot_use_s_07 == 7
}
replace fod_bank_07 = 1 if fod_hstead_n > 3 & fod_hstead_n != .
*max of fod_hstead_n is 6
replace fod_bank_07 = 1 if oth_fb_07 == 1

foreach i of num 1/8 {
gen plot`i'_fod_shrub_07 = 0
	foreach j of num 5 14 15 {
	replace plot`i'_fod_shrub_07 = 1 if plot`i'_plot_tr_spe_07_`j' == 1
	}
}

foreach i of num 1/8 {
replace fod_bank_07 = 1 if plot`i'_fod_shrub_07 == 1 & plot`i'_fodd_07 == 1
}

gen i_fal_07 = 0
foreach i of num 1/10 {
replace i_fal_07 = 1 if plot`i'_plot_use_s_07 == 10
}

egen n_com_prac_07 = rowtotal(woodlot_07 orchard_07 fod_bank_07 i_fal_07)
gen com_prac_07 = 0
replace com_prac_07 = 1 if n_com_prac_07 >= 1 & n_com_prac_07 != .
label var com_prac_07 "At Least One Complementary AF Practice"


***Indicator 2.1 Farm Plot Tree Density***


egen numplots_tr_07 = rowtotal(plot1_plot_tr_07 plot2_plot_tr_07 plot3_plot_tr_07 plot4_plot_tr_07 plot5_plot_tr_07 plot6_plot_tr_07 plot7_plot_tr_07 plot8_plot_tr_07 plot9_plot_tr_07 plot10_plot_tr_07)

*at least 50 trees on plot
foreach i of num 1/8 {
gen plot`i'_tr_50_07 = 1 if plot`i'_plot_tr_07 == 1 & plot`i'_plot_tr_n_07 >= 5
}

*at least 20 trees on plot
foreach i of num 1/8 {
gen plot`i'_tr_20_07 = 1 if plot`i'_plot_tr_07 == 1 & plot`i'_plot_tr_n_07 >= 4
}

*at least one plot with more than 50 trees
gen plot_any_tr_50_07 = 0
foreach i of num 1/8 {
replace plot_any_tr_50_07 = 1 if plot`i'_tr_50_07 == 1
}

*all plots with at least 20 trees
egen numplots_tr_20_07 = rowtotal(plot1_tr_20_07 plot2_tr_20_07 plot3_tr_20_07 plot4_tr_20_07 plot5_tr_20_07 plot6_tr_20_07 plot7_tr_20_07 plot8_tr_20_07)

gen all_tr_20_07 = 0
replace all_tr_20_07 = 1 if numplots == numplots_tr_20_07

*Binary indicator for tree density: all plots have more than 20 trees, at least one more than 50
gen tree_density_bin_07 = 0
replace tree_density_bin_07 = 1 if plot_any_tr_50_07 == 1 & all_tr_20_07 == 1
label var tree_density_bin_07 "50 trees on one plot, 20 on all others"

*Alternate indicator: 1 plot with 50 trees or all plots with at least 20

gen tree_dens_alt_07 = 0
replace tree_dens_alt_07 = 1 if plot_any_tr_50_07 == 1
replace tree_dens_alt_07 = 1 if all_tr_20_07 == 1 & numplots > 1
label var tree_dens_alt_07 "50 trees on one plot or 20 on all"


***Indicator 2.2 Farm Plot Tree Product Sales***

*at least one tree product from farm plot produced for sale:
gen tr_pro_sale_07 = 0
label var tr_pro_sale_07 "Tree Products from Farm Plots for Sale"

foreach i of num 1/8{
	foreach j of num 2 4 6 8 11 {
	replace tr_pro_sale_07 = 1 if plot`i'_plot_tr_pro_t_07_`j' == 1 & plot`i'_plot_use_s_07 == 1 
	}
}
*products from other farm plots
foreach i of num 2 4 6 8 11 {
replace tr_pro_sale_07 = 1 if oth_tr_pro_t_07_`i' == 1
}

***Indicator 2.3 Intensity of Complementary Practices***

*variable for orchard with over 10 trees, or orchard in other parcel
gen orchard_hi_07 = 0
foreach i of num 1/8 {
replace orchard_hi_07 = 1 if plot`i'_plot_use_s_07 == 2 & plot`i'_plot_tr_n_07 >= 3 & plot`i'_plot_tr_n_07 != . 
}
replace orchard_hi_07 = 1 if oth_orc_07 == 1 

*variable for wood lot with over 100 trees
gen woodlot_hi_07 = 0
foreach i of num 1/8 {
replace woodlot_hi_07 = 1 if plot`i'_plot_use_s_07 == 3 & plot`i'_plot_tr_n_07 >= 5 & plot`i'_plot_tr_n_07 != . 
}
replace woodlot_hi_07 = 1 if oth_w_lot_07 == 1

*variable for tree based fodder bank with over 50 shrubs
gen fod_bank_hi_07 = 0
foreach i of num 1/8 {
replace fod_bank_hi_07 = 1 if plot`i'_plot_use_s_07 == 7 & plot`i'_plot_tr_n_07 >= 5 & plot`i'_plot_tr_n_07 != .
}

replace fod_bank_hi_07 = 1 if oth_fb_07 == 1

foreach i of num 1/8 {
replace fod_bank_hi_07 = 1 if plot`i'_fod_shrub_07 == 1 & plot`i'_fodd_07 == 1 & plot`i'_plot_tr_n_07 >= 5 & plot`i'_plot_tr_n_07 != .
}

gen comp_prac_int_07 = 0
replace comp_prac_int_07 = 1 if orchard_hi_07 == 1 | woodlot_hi_07 == 1 | fod_bank_hi_07 == 1
label var comp_prac_int_07 "Intensity of Complementary Practices"


***Indicator 2.4 Sales from Complementary Practices***

*products for sale from complementary practices on non-farming plots
gen comp_prac_sale_07 = 0
label var comp_prac_sale_07 "Products for Sale from Complementary Practices"
foreach i of num 1/8{
	foreach j of num 2 4 6 8 11 {
		foreach k of num 2 3 7 10 {
		replace comp_prac_sale_07 = 1 if plot`i'_plot_tr_pro_t_07_`j' == 1 & plot`i'_plot_use_s_07 == `k'
		}
	}
}

*tree products from orchards
foreach i of num 1/6 {
	foreach j of num 2 4 6 8 11 {
	replace comp_prac_sale_07 = 1 if plot`i'_plot_fr_pro_07_`j' == 1
	}
}

*tree products from woodlots
foreach i of num 1/8 10 {
	foreach j of num 2 4 6 8 11 {
	replace comp_prac_sale_07 = 1 if plot`i'_plot_wl_pro_07_`j' == 1
	}
}

*tree products from fodder banks
*no tree products from fodder banks sold in 2007

*tree products from improved fallows
foreach i of num 1 2 5 {
	foreach j of num 2 4 6 8 11 {
	replace comp_prac_sale_07 = 1 if plot`i'_plot_i_fal_pro_07_`j' == 1
	}
}

*products from other orchards
foreach i of num 2 4 6 8 11 {
replace comp_prac_sale_07 = 1 if oth_orc_07 == 1 & oth_orc_pro_t_07_`i' == 1
}
*products from other woodlots
foreach i of num 2 4 6 8 11 {
replace comp_prac_sale_07 = 1 if oth_w_lot_07 == 1 & oth_w_lot_pro_t_07_`i' == 1
}
*no products reported from other fodder banks



***Indicator 3.1 Leguminous Shrubs***

gen legume_shrub_07 = 0
label var legume_shrub_07 "Introduced Leguminous Shrubs"

*legume shrubs in farm plots
foreach i of num 1/8 {
	foreach j of num 5 14 15 {
	replace legume_shrub_07 = 1 if plot`i'_plot_tr_spe_07_`j' == 1
	}
}

*legume shrubs in woodlots
foreach i of num 1/8 10 {
	foreach j of num 5 14 15 {
	replace legume_shrub_07 = 1 if plot`i'_plot_wl_sp_07_`j' == 1
	}
}

*legume shrubs in orchards
foreach i of num 1/6 {
	foreach j of num 5 14 15 {
	replace legume_shrub_07 = 1 if plot`i'_plot_fr_sp_07_`j' == 1
	}
}

*legume shrubs in fodder banks
*no legume shrubs reported in fodder banks for 2007

*legume shrubs in improved fallows
foreach i of num 1 2 3 5{ 
	foreach j of num 5 14 15 {
	replace legume_shrub_07 = 1 if plot`i'_plot_i_fal_sp_07_`j' == 1
	}
}

*legume shrubs in other farm plots
foreach i of num 5 14 15 {
replace legume_shrub_07 = 1 if oth_tr_spe_07_`i' == 1
}

*legume shrubs in other orchards
foreach i of num 5 14 15 {
replace legume_shrub_07 = 1 if oth_w_lot_s_t_07_`i' == 1
}

*legume shrubs in other woodlots
foreach i of num 5 14 15 {
replace legume_shrub_07 = 1 if oth_orc_s_t_07_`i' == 1
}


*legume shrubs in other fodder banks
foreach i of num 5 14 15 {
replace legume_shrub_07 = 1 if oth_fb_s_t_07_`i' == 1
}


***Indicator 3.2 Presence of at least 3 long-term exotics promoted by Vi***

*Annona spp
unab annona : plot*tr_spe_07_3 
egen annon_np_07 = rowtotal(`annona' oth_tr_spe_07_3 oth_w_lot_s_t_07_3 oth_orc_s_t_07_3 oth_fb_s_t_07_3 oth_w_lot_s_t_07_3 oth_fb_s_t_07_3) 
gen annon_yn_07 = 0
replace annon_yn_07 = 1 if annon_np_07 > 0 & annon_np_07 != .

*casuarina
unab casua : plot*tr_spe_07_8
egen casua_np_07 = rowtotal(`casua' oth_tr_spe_07_8 oth_w_lot_s_t_07_8 oth_orc_s_t_07_8 oth_fb_s_t_07_8 oth_w_lot_s_t_07_8 oth_fb_s_t_07_8) 
gen casua_yn_07 = 0
replace casua_yn_07 = 1 if casua_np_07 > 0 & casua_np_07 != .

*Grevillea
unab grevi : plot*tr_spe_07_13
egen grevi_np_07 = rowtotal(`grevi' oth_tr_spe_07_13 oth_w_lot_s_t_07_13 oth_orc_s_t_07_13 oth_fb_s_t_07_13 oth_w_lot_s_t_07_13 oth_fb_s_t_07_13) 
gen grevi_yn_07 = 0
replace grevi_yn_07 = 1 if grevi_np_07 > 0 & grevi_np_07 != .

*Persea americana (avocado)
unab avoca : plot*tr_spe_07_33
egen avoca_np_07 = rowtotal(`avoca' oth_tr_spe_07_33 oth_w_lot_s_t_07_33 oth_orc_s_t_07_33 oth_fb_s_t_07_33 oth_w_lot_s_t_07_33 oth_fb_s_t_07_33) 
gen avoca_yn_07 = 0
replace avoca_yn_07 = 1 if avoca_np_07 > 0 & avoca_np_07 != .

*Syzigium
unab syzig : plot*tr_spe_07_37
egen syzig_np_07 = rowtotal(`syzig' oth_tr_spe_07_37 oth_w_lot_s_t_07_37 oth_orc_s_t_07_37 oth_fb_s_t_07_37 oth_w_lot_s_t_07_37 oth_fb_s_t_07_37) 
gen syzig_yn_07 = 0
replace syzig_yn_07 = 1 if syzig_np_07 > 0 & syzig_np_07 != .

*Casimiroa edulis
unab casim : plot*tr_spe_07_40
egen casim_np_07 = rowtotal(`casim' oth_tr_spe_07_40 oth_w_lot_s_t_07_40 oth_orc_s_t_07_40 oth_fb_s_t_07_40 oth_w_lot_s_t_07_40 oth_fb_s_t_07_40) 
gen casim_yn_07 = 0
replace casim_yn_07 = 1 if casim_np_07 > 0 & casim_np_07 != .

*number of exotic tree species anywhere on farm
egen spe_exo_n_07 = rowtotal(annon_yn_07 casua_yn_07 grevi_yn_07 avoca_yn_07 syzig_yn_07 casim_yn_07)

gen long_spe_exo_07 = 0
replace long_spe_exo_07 = 1 if spe_exo_n_07 >= 3 & spe_exo_n_07 != .
label var long_spe_exo_07 "Promoted Exotic Species"


***Indicator 3.3 Long-term Natives Promoted by Vi***

*Cordia africana
unab cordia: plot*tr_spe_07_11
egen cordia_np_07 = rowtotal(`cordia' oth_tr_spe_07_11 oth_w_lot_s_t_07_11 oth_orc_s_t_07_11 oth_fb_s_t_07_11 oth_w_lot_s_t_07_11 oth_fb_s_t_07_11) 
gen cordia_yn_07 = 0
replace cordia_yn_07 = 1 if cordia_np_07 > 0 & cordia_np_07 != .

*Markhamia lutea
unab markh: plot*tr_spe_07_26
egen markh_np_07 = rowtotal(`markh' oth_tr_spe_07_26 oth_w_lot_s_t_07_26 oth_orc_s_t_07_26 oth_fb_s_t_07_26 oth_w_lot_s_t_07_26 oth_fb_s_t_07_26) 
gen markh_yn_07 = 0
replace markh_yn_07 = 1 if markh_np_07 > 0 & markh_np_07 != .

*Croton megalocarpus
unab crmeg: plot*tr_spe_07_16
egen crmeg_np_07 = rowtotal(`crmeg' oth_tr_spe_07_16 oth_w_lot_s_t_07_16 oth_orc_s_t_07_16 oth_fb_s_t_07_16 oth_w_lot_s_t_07_16 oth_fb_s_t_07_16) 
gen crmeg_yn_07 = 0
replace crmeg_yn_07 = 1 if crmeg_np_07 > 0 & crmeg_np_07 != .

*Croton macrostachus
unab crmac: plot*tr_spe_07_12
egen crmac_np_07 = rowtotal(`crmac' oth_tr_spe_07_12 oth_w_lot_s_t_07_12 oth_orc_s_t_07_12 oth_fb_s_t_07_12 oth_w_lot_s_t_07_12 oth_fb_s_t_07_12) 
gen crmac_yn_07 = 0
replace crmac_yn_07 = 1 if crmac_np_07 > 0 & crmac_np_07 != .

*Prunus africana
unab prunu: plot*tr_spe_07_35
egen prunu_np_07 = rowtotal(`prunu' oth_tr_spe_07_35 oth_w_lot_s_t_07_35 oth_orc_s_t_07_35 oth_fb_s_t_07_35 oth_w_lot_s_t_07_35 oth_fb_s_t_07_35) 
gen prunu_yn_07 = 0
replace prunu_yn_07 = 1 if prunu_np_07 > 0 & prunu_np_07 != .

*Olea capensis
unab olcap: plot*tr_spe_07_32
egen olcap_np_07 = rowtotal(`olcap' oth_tr_spe_07_32 oth_w_lot_s_t_07_32 oth_orc_s_t_07_32 oth_fb_s_t_07_32 oth_w_lot_s_t_07_32 oth_fb_s_t_07_32) 
gen olcap_yn_07 = 0
replace olcap_yn_07 = 1 if olcap_np_07 > 0 & olcap_np_07 != .

*Vitex keniensis
unab vitex: plot*tr_spe_07_38
egen vitex_np_07 = rowtotal(`vitex' oth_tr_spe_07_38 oth_w_lot_s_t_07_38 oth_orc_s_t_07_38 oth_fb_s_t_07_38 oth_w_lot_s_t_07_38 oth_fb_s_t_07_38) 
gen vitex_yn_07 = 0
replace vitex_yn_07 = 1 if vitex_np_07 > 0 & vitex_np_07 != .

*Podocarpus falcatus
unab podoc: plot*tr_spe_07_34
egen podoc_np_07 = rowtotal(`podoc' oth_tr_spe_07_34 oth_w_lot_s_t_07_34 oth_orc_s_t_07_34 oth_fb_s_t_07_34 oth_w_lot_s_t_07_34 oth_fb_s_t_07_34) 
gen podoc_yn_07 = 0
replace podoc_yn_07 = 1 if podoc_np_07 > 0 & podoc_np_07 != .

*number of native tree species anywhere on farm
egen spe_nat_n_07 = rowtotal(cordia_yn_07 markh_yn_07 crmeg_yn_07 crmac_yn_07 prunu_yn_07 olcap_yn_07 vitex_yn_07 podoc_yn_07)

gen long_spe_nat_07 = 0
replace long_spe_nat_07 = 1 if spe_nat_n_07 >= 3 & spe_nat_n_07 != .
label var long_spe_nat_07 "Promoted Native Species"


***    AF Index Totals      ***

foreach var of varlist tree_dens_alt_07 mn_plot_pro_16 tree_nrm_16 com_prac_16 mn_plot_pro_07 tree_nrm_07 com_prac_07 legume_shrub_16 long_spe_exo_16 long_spe_nat_16 legume_shrub_07 long_spe_exo_07 long_spe_nat_07 {
gen `var'_ind = `var'/9
local `var'_lbl: variable label `var'
label var `var'_ind `"``var'_lbl'"'
}

foreach var of varlist tree_density_bin_16 tree_dens_alt_16 tr_pro_sale_16 comp_prac_int_16 comp_prac_sale_16 tree_density_bin_07 tr_pro_sale_07 comp_prac_int_07 comp_prac_sale_07 {
gen `var'_ind = `var'/12
local `var'_lbl: variable label `var'
label var `var'_ind `"``var'_lbl'"'
}


*Dimension 1: Practice Uptake
egen af_ind_d1_16 = rowtotal(mn_plot_pro_16_ind tree_nrm_16_ind com_prac_16_ind)
egen af_ind_d1_07 = rowtotal(mn_plot_pro_07_ind tree_nrm_07_ind com_prac_07_ind)
label var af_ind_d1_16 "D1: Practice Uptake 16"
label var af_ind_d1_07 "D1: Practice Uptake 07"


*Dimension 2: Intensity of Practice
egen af_ind_d2_16 = rowtotal(tree_dens_alt_16_ind tr_pro_sale_16_ind comp_prac_int_16_ind comp_prac_sale_16_ind)
egen af_ind_d2_07 = rowtotal(tree_dens_alt_07_ind tr_pro_sale_07_ind comp_prac_int_07_ind comp_prac_sale_07_ind)
label var af_ind_d2_16 "D2: Practice Intensity 16"
label var af_ind_d2_07 "D2: Practice Intensity 07"

*Dimension 3: Tree Species
egen af_ind_d3_16 = rowtotal(legume_shrub_16_ind long_spe_exo_16_ind long_spe_nat_16_ind)
egen af_ind_d3_07 = rowtotal(legume_shrub_07_ind long_spe_exo_07_ind long_spe_nat_07_ind)
label var af_ind_d3_16 "D3: Species Diversity 16"
label var af_ind_d3_07 "D3: Species Diversity 07"

*Full Index
egen af_ind_16 = rowtotal(af_ind_d1_16 af_ind_d2_16 af_ind_d3_16)
egen af_ind_07 = rowtotal(af_ind_d1_07 af_ind_d2_07 af_ind_d3_07)
label var af_ind_16 "AF Index Score 16"
label var af_ind_07 "AF Index Score 07"


*Differenced AF Index
gen af_ind_dif = af_ind_16 - af_ind_07
label var af_ind_dif "Differenced AF Index"

global af_ind_vars "mn_plot_pro_16_ind tree_nrm_16_ind com_prac_16_ind mn_plot_pro_07_ind tree_nrm_07_ind com_prac_07_ind tree_density_bin_16_ind tr_pro_sale_16_ind comp_prac_int_16_ind comp_prac_sale_16_ind tree_density_bin_07_ind tr_pro_sale_07_ind comp_prac_int_07_ind comp_prac_sale_07_ind legume_shrub_16_ind long_spe_exo_16_ind long_spe_nat_16_ind legume_shrub_07_ind long_spe_exo_07_ind long_spe_nat_07_ind af_ind_d1_16 af_ind_d2_16 af_ind_d3_16 af_ind_d1_07 af_ind_d2_07 af_ind_d3_07 af_ind_16 af_ind_07 af_ind_dif"
global loc_vars "farmer_code _hh_loc_latitude _hh_loc_longitude vi_group prog_area AEZONE dist_tarma project county sub_county location sub_loc oth_sub_loc village groupid vilid"


*Binary for high and low adopters
gen af_hi_16 = 0
replace af_hi_16 = 1 if af_ind_16 > 0.2




***Other Land Management Practices***

**2016**
gen fallow_16 = 0
foreach i of num 1/10 {
replace fallow_16 = 1 if plot`i'_plot_prac_16_1 == 1
}
label var fallow_16 "Fallowing (not improved)"

gen imp_fallo_g_16 = 0
foreach i of num 1/10 {
replace imp_fallo_g_16 = 1 if plot`i'_plot_prac_16_2 == 1
}
label var imp_fallo_g_16 "Improved fallow (grass)"

gen imp_fallo_t_16 = 0
foreach i of num 1/10 {
replace imp_fallo_t_16 = 1 if plot`i'_plot_prac_16_3 == 1
}
label var imp_fallo_t_16 "Improved fallow (tree)"

gen irrig_16 = 0
foreach i of num 1/10 {
replace irrig_16 = 1 if plot`i'_plot_prac_16_4 == 1
}
label var irrig_16 "Irrigation"

gen mulch_16 = 0
foreach i of num 1/10 {
replace mulch_16 = 1 if plot`i'_plot_prac_16_5 == 1
}
label var mulch_16 "Mulching"

gen rotate_16 = 0
foreach i of num 1/10 {
replace rotate_16 = 1 if plot`i'_plot_prac_16_6 == 1
}
label var rotate_16 "Crop rotation/sequential cropping"

gen cover_16 = 0
foreach i of num 1/10 {
replace cover_16 = 1 if plot`i'_plot_prac_16_7 == 1
}
label var cover_16 "Cover crops"

gen inter_16 = 0
foreach i of num 1/10 {
replace inter_16 = 1 if plot`i'_plot_prac_16_8 == 1
}
label var inter_16 "Intercropping"

gen relay_16 = 0
foreach i of num 1/10 {
replace relay_16 = 1 if plot`i'_plot_prac_16_9 == 1
}
label var relay_16 "Relay cropping"

gen chem_f_16 = 0
foreach i of num 1/10 {
replace chem_f_16 = 1 if plot`i'_plot_prac_16_10 == 1
}
label var chem_f_16 "Chemical fertilizer"

gen a_manu_16 = 0
foreach i of num 1/10 {
replace a_manu_16 = 1 if plot`i'_plot_prac_16_11 == 1
}
label var a_manu_16 "Animal manure"

gen gr_manu_16 = 0
foreach i of num 1/10 {
replace gr_manu_16 = 1 if plot`i'_plot_prac_16_12 == 1
}
label var gr_manu_16 "Green manure"

gen chem_p_16 = 0
foreach i of num 1/10 {
replace chem_p_16 = 1 if plot`i'_plot_prac_16_13 == 1
}
label var chem_p_16 "Chemical pesticides"

gen orga_p_16 = 0
foreach i of num 1/10 {
replace orga_p_16 = 1 if plot`i'_plot_prac_16_14 == 1
}
label var orga_p_16 "Organic pesticides"

gen terrace_16 = 0
foreach i of num 1/10 {
replace terrace_16 = 1 if plot`i'_plot_prac_16_15 == 1
}
label var terrace_16 "Terraces"

gen trench_16 = 0
foreach i of num 1/10 {
replace trench_16 = 1 if plot`i'_plot_prac_16_16 == 1
}
label var trench_16 "Trenches"

gen compost_16 = 0
foreach i of num 1/10 {
replace compost_16 = 1 if plot`i'_plot_prac_16_17 == 1
}
label var compost_16 "Compost manure"

gen basin_16 = 0
foreach i of num 1/10 {
replace basin_16 = 1 if plot`i'_plot_prac_16_18 == 1
}
label var basin_16 "Planting basins"

gen h_moon_16 = 0
foreach i of num 1/10 {
replace h_moon_16 = 1 if plot`i'_plot_prac_16_19 == 1
}
label var h_moon_16 "Half moons"

gen tr_line_16 = 0
foreach i of num 1/10 {
replace tr_line_16 = 1 if plot`i'_plot_prac_16_20 == 1
}
label var tr_line_16 "Trash lines"

gen str_crop_16 = 0
foreach i of num 1/10 {
replace str_crop_16 = 1 if plot`i'_plot_prac_16_21 == 1
}
label var str_crop_16 "Strip cropping"

gen con_bund_16 = 0
foreach i of num 1/10 {
replace con_bund_16 = 1 if plot`i'_plot_prac_16_22 == 1
}
label var con_bund_16 "Contour bunds (earth ridges)"

gen redu_till_16 = 0
foreach i of num 1/10 {
replace redu_till_16 = 1 if plot`i'_plot_prep_16 == 4 | plot`i'_plot_prep_16 == 5
}
label var redu_till_16 "Reduced tillage"


**2007**

gen fallow_07 = 0
foreach i of num 1/10 {
replace fallow_07 = 1 if plot`i'_plot_prac_07_1 == 1
}
label var fallow_07 "Fallowing (not improved)"

gen imp_fallo_g_07 = 0
foreach i of num 1/10 {
replace imp_fallo_g_07 = 1 if plot`i'_plot_prac_07_2 == 1
}
label var imp_fallo_g_07 "Improved fallow (grass)"

gen imp_fallo_t_07 = 0
foreach i of num 1/10 {
replace imp_fallo_t_07 = 1 if plot`i'_plot_prac_07_3 == 1
}
label var imp_fallo_t_07 "Improved fallow (tree)"

gen irrig_07 = 0
foreach i of num 1/10 {
replace irrig_07 = 1 if plot`i'_plot_prac_07_4 == 1
}
label var irrig_07 "Irrigation"

gen mulch_07 = 0
foreach i of num 1/10 {
replace mulch_07 = 1 if plot`i'_plot_prac_07_5 == 1
}
label var mulch_07 "Mulching"

gen rotate_07 = 0
foreach i of num 1/10 {
replace rotate_07 = 1 if plot`i'_plot_prac_07_6 == 1
}
label var rotate_07 "Crop rotation/sequential cropping"

gen cover_07 = 0
foreach i of num 1/10 {
replace cover_07 = 1 if plot`i'_plot_prac_07_7 == 1
}
label var cover_07 "Cover crops"

gen inter_07 = 0
foreach i of num 1/10 {
replace inter_07 = 1 if plot`i'_plot_prac_07_8 == 1
}
label var inter_07 "Intercropping"

gen relay_07 = 0
foreach i of num 1/10 {
replace relay_07 = 1 if plot`i'_plot_prac_07_9 == 1
}
label var relay_07 "Relay cropping"

gen chem_f_07 = 0
foreach i of num 1/10 {
replace chem_f_07 = 1 if plot`i'_plot_prac_07_10 == 1
}
label var chem_f_07 "Chemical fertilizer"

gen a_manu_07 = 0
foreach i of num 1/10 {
replace a_manu_07 = 1 if plot`i'_plot_prac_07_11 == 1
}
label var a_manu_07 "Animal manure"

gen gr_manu_07 = 0
foreach i of num 1/10 {
replace gr_manu_07 = 1 if plot`i'_plot_prac_07_12 == 1
}
label var gr_manu_07 "Green manure"

gen chem_p_07 = 0
foreach i of num 1/10 {
replace chem_p_07 = 1 if plot`i'_plot_prac_07_13 == 1
}
label var chem_p_07 "Chemical pesticides"

gen orga_p_07 = 0
foreach i of num 1/10 {
replace orga_p_07 = 1 if plot`i'_plot_prac_07_14 == 1
}
label var orga_p_07 "Organic pesticides"

gen terrace_07 = 0
foreach i of num 1/10 {
replace terrace_07 = 1 if plot`i'_plot_prac_07_15 == 1
}
label var terrace_07 "Terraces"

gen trench_07 = 0
foreach i of num 1/10 {
replace trench_07 = 1 if plot`i'_plot_prac_07_16 == 1
}
label var trench_07 "Trenches"

gen compost_07 = 0
foreach i of num 1/10 {
replace compost_07 = 1 if plot`i'_plot_prac_07_17 == 1
}
label var compost_07 "Compost manure"

gen basin_07 = 0
foreach i of num 1/10 {
replace basin_07 = 1 if plot`i'_plot_prac_07_18 == 1
}
label var basin_07 "Planting basins"

gen h_moon_07 = 0
foreach i of num 1/10 {
replace h_moon_07 = 1 if plot`i'_plot_prac_07_19 == 1
}
label var h_moon_07 "Half moons"

gen tr_line_07 = 0
foreach i of num 1/10 {
replace tr_line_07 = 1 if plot`i'_plot_prac_07_20 == 1
}
label var tr_line_07 "Trash lines"

gen str_crop_07 = 0
foreach i of num 1/10 {
replace str_crop_07 = 1 if plot`i'_plot_prac_07_21 == 1
}
label var str_crop_07 "Strip cropping"

gen con_bund_07 = 0
foreach i of num 1/10 {
replace con_bund_07 = 1 if plot`i'_plot_prac_07_22 == 1
}
label var con_bund_07 "Contour bunds (earth ridges)"

gen redu_till_07 = 0
foreach i of num 1/8 {
replace redu_till_07 = 1 if plot`i'_plot_prep_07 == 4 | plot`i'_plot_prep_07 == 5
}
label var redu_till_07 "Reduced tillage"

***SALM Index***

*2016
gl salm "cover_16 gr_manu_16 rotate_16 inter_16 relay_16 str_crop_16 mulch_16 imp_fallo_g_16 imp_fallo_t_16 a_manu_16 compost_16 redu_till_16 terrace_16 trench_16 con_bund_16"

foreach v of global salm {
gen `v'_ind = `v'/15
local `v'_lbl: variable label `v'
label var `v'_ind `"``v'_lbl'"'
}

global salm_ind: subinstr global salm "_16" "_16_ind", all

egen salm_ind_16 = rowtotal($salm_ind)
lab var salm_ind_16 "SALM Practice Index 2016"

*2007
gl salm_07 "cover_07 gr_manu_07 rotate_07 inter_07 relay_07 str_crop_07 mulch_07 imp_fallo_g_07 imp_fallo_t_07 a_manu_07 compost_07 redu_till_07 terrace_07 trench_07 con_bund_07"

foreach v of global salm_07 {
gen `v'_ind = `v'/15
local `v'_lbl: variable label `v'
label var `v'_ind `"``v'_lbl'"'
}

global salm_ind_07: subinstr global salm_07 "_07" "_07_ind", all

egen salm_ind_07 = rowtotal($salm_ind_07)
lab var salm_ind_07 "SALM Practice Index 2007"

*Differenced 

global salm_stub: subinstr global salm "_16" "", all

foreach v of global salm_stub {
gen `v'_dif = `v'_16 - `v'_07
}

global salm_dif: subinstr global salm "_16" "_dif", all

egen salm_ind_dif = rowtotal($salm_dif)
lab var salm_ind_dif "Differenced SALM Index"




*==============================*
*Intermediate Outcome Variables*
*==============================*

***1. Income from Agroforestry Products***

unab plot_ksh : plot*plot_tr_ksh_16 plot*_plot_wl_ksh_16 plot*_plot_fr_ksh_16 plot*_plot_fod_ksh_16 plot*_plot_i_fal_ksh_16
egen af_prod_sale_16 = rowtotal(`plot_ksh' oth_tr_ksh_16 oth_w_lot_ksh_16 oth_orc_ksh_16 oth_fb_ksh_16)
lab var af_prod_sale_16 "Income from AF Products 2016"

unab plot_ksh07 : plot*plot_tr_ksh_07 plot*_plot_wl_ksh_07 plot*_plot_fr_ksh_07 
egen af_prod_sale_07 = rowtotal(`plot_ksh07' oth_tr_ksh_07 oth_w_lot_ksh_07 oth_orc_ksh_07 oth_fb_ksh_07)
lab var af_prod_sale_07 "Income from AF Products 2007"

*trim outliers
foreach var of varlist af_prod_sale_16 af_prod_sale_07 {
summarize `var' if `var' != 0, detail
replace `var' = r(p75) + (5 * (r(p75) - r(p25))) if `var' > r(p75) + (5 * (r(p75) - r(p25)))
}

*differenced income from AF products
gen af_prod_sale_dif = af_prod_sale_16 - af_prod_sale_07
lab var af_prod_sale_dif "Differenced Income from AF Products"


***2. Estimated Cash Value of Firewood Harvested from Farm***

*cash value of harvested fuelwood 2016, outliers trimmed
sum fire_w_16_cash if fire_w_16_cash!=0, detail
replace fire_w_16_cash = r(p75) + (5 * (r(p75) - r(p25))) if fire_w_16_cash > r(p75) + (5 * (r(p75) - r(p25))) & fire_w_16_cash!=.
lab var fire_w_16_cash "Cash Value of Collected Firewood 2016"

*cash value of harvested fuelwood 2007, outliers trimmed
sum fire_w_07_cash if fire_w_07_cash!=0, detail
replace fire_w_07_cash = r(p75) + (5 * (r(p75) - r(p25))) if fire_w_07_cash > r(p75) + (5 * (r(p75) - r(p25))) & fire_w_07_cash!=.
lab var fire_w_07_cash "Cash Value of Collected Firewood 2007"

*generate outcome variables
gen fw_cash_val_16 = fire_w_16_cash
gen fw_cash_val_07 = fire_w_07_cash
gen fw_cash_val_dif = fire_w_16_cash - fire_w_07_cash
lab var fw_cash_val_dif "Differenced Cash Value of Collected Firewood"

***3. Estimated hours collecting firewood per month***

*average time in 2016
*==================
sum fire_w_16_time if fire_w_16_time != 0, detail
replace fire_w_16_time=0.5 if fire_w_16_time==30
replace fire_w_16_time=0.25 if fire_w_16_time==15
replace fire_w_16_time=1 if fire_w_16_time==60
replace fire_w_16_time=0.33 if fire_w_16_time==20
replace fire_w_16_time= r(p75) + (5 * (r(p75) - r(p25))) if fire_w_16_time > r(p75) + (5 * (r(p75) - r(p25))) & fire_w_16_time!=.

*time by source in 2016
*=======================

label variable fire_w_16_ms
label define fire_w_16_ms 1"Own farm"2"Communal land"3"Government forest"4"Other Government land"5"Other private lands (e.g. neighbour's)"6"Purchased from the market or others"7"Other (specify)"
label values fire_w_16_ms fire_w_16_ms
tab fire_w_16_ms

sum fire_w_16_time if fire_w_16_ms==1, detail
sum fire_w_16_time if fire_w_16_ms==2, detail
sum fire_w_16_time if fire_w_16_ms==3, detail
sum fire_w_16_time if fire_w_16_ms==4, detail
sum fire_w_16_time if fire_w_16_ms==5, detail
sum fire_w_16_time if fire_w_16_ms==6, detail

*average time in 2007
*==================
sum fire_w_07_time if fire_w_07_time != 0, detail
replace fire_w_07_time=0.5 if fire_w_07_time==30
replace fire_w_07_time=1 if fire_w_07_time==60
replace fire_w_07_time=0.25 if fire_w_07_time==15
replace fire_w_07_time=0.33 if fire_w_07_time==20
replace fire_w_07_time= r(p75) + (5 * (r(p75) - r(p25))) if fire_w_07_time> r(p75) + (5 * (r(p75) - r(p25)))& fire_w_07_time!=.

*time by source in 2007
*=======================

sum fire_w_07_time if fire_w_07_ms==1, detail
sum fire_w_07_time if fire_w_07_ms==2, detail
sum fire_w_07_time if fire_w_07_ms==3, detail
sum fire_w_07_time if fire_w_07_ms==4, detail
sum fire_w_07_time if fire_w_07_ms==5, detail
sum fire_w_07_time if fire_w_07_ms==6, detail

**frequency of collection 2016**, outliers reduced to 30
sum fire_w_16_freq, detail
gen fire_w_16_freq_out = 1 if fire_w_16_freq > 30 & fire_w_16_freq!=.
replace fire_w_16_freq= 30 if fire_w_16_freq> 30 & fire_w_16_freq!=.
sum fire_w_16_freq, detail

**frequency of collection 2007**, outliers reduced to 30
sum fire_w_07_freq, detail
gen fire_w_07_freq_out = 1 if fire_w_07_freq > 30 & fire_w_07_freq!=.
replace fire_w_07_freq= 30 if fire_w_07_freq > 30& fire_w_07_freq!=.
sum fire_w_07_freq, detail

**total time taken to collect firewood 2016**

gen fw_hour_16 = fire_w_16_time * fire_w_16_freq
label variable fw_hour_16 "hours per month collecting firewood 2016"

sum fw_hour_16 if fw_hour_16 != 0, detail
replace fw_hour_16 = r(p75) + (5 * (r(p75) - r(p25))) if fw_hour_16 > r(p75) + (5 * (r(p75) - r(p25))) & fw_hour_16!=.

**total time taken to collect firewood 2007**

gen fw_hour_07 = fire_w_07_time * fire_w_07_freq
label variable fw_hour_07 "hours per month collecting firewood 2007"

sum fw_hour_07 if fw_hour_07 != 0, detail
replace fw_hour_07 = r(p75) + (5 * (r(p75) - r(p25))) if fw_hour_07 > r(p75) + (5 * (r(p75) - r(p25))) & fw_hour_07!=.

*differenced value
gen fw_hour_dif = fw_hour_16 - fw_hour_07
lab var fw_hour_dif "Differenced Hours Collecting Firewood"


***4. Average % change in milk yields among dairy producers***

gen own_dairy_16 = 0
foreach i of num 7 8 11 12 {
replace own_dairy_16 = 1 if typ_live_16_`i' == 1
}

gen own_dairy_07 = 0
foreach i of num 7 8 11 12 {
replace own_dairy_07 = 1 if typ_live_07_`i' == 1
}


**dar_prod

g dar_prod = (own_dairy_16 ==1 & own_dairy_07==1) 


*=====================
**improved cows 2016**
*=============================

sum d_cow_n_imp_16 if d_cow_n_imp_16!=0, detail
replace d_cow_n_imp_16 = r(p75) + (5 * (r(p75) - r(p25))) if d_cow_n_imp_16 > r(p75) + (5 * (r(p75) - r(p25))) & d_cow_n_imp_16!=.
label variable d_cow_n_imp_16 "number of improved cows owned by the household in 2016"

*replace d_cow_lit_imp_16=d_cow_lit_imp_16/d_cow_n_imp_16 if d_cow_n_imp_16>1
sum d_cow_lit_imp_16 if d_cow_lit_imp_16!=0, detail
replace d_cow_lit_imp_16 = r(p75) + (5 * (r(p75) - r(p25))) if d_cow_lit_imp_16 > r(p75) + (5 * (r(p75) - r(p25))) & d_cow_lit_imp_16!=.
label variable d_cow_lit_imp_16 "average milk (litres)produced per improved cow per day during their peak in 2016"

**improved cows 2007**
*============================

sum d_cow_n_imp_07 if d_cow_n_imp_07!=0, detail
replace d_cow_n_imp_07= r(p75) + (5 * (r(p75) - r(p25))) if d_cow_n_imp_07 > r(p75) + (5 * (r(p75) - r(p25))) & d_cow_n_imp_07!=.
label variable d_cow_n_imp_07 "number of improved cows owned by the household in 2007"

sum d_cow_lit_imp_07, detail
replace d_cow_lit_imp_07= r(p75) + (5 * (r(p75) - r(p25))) if d_cow_lit_imp_07 > r(p75) + (5 * (r(p75) - r(p25))) & d_cow_lit_imp_07!=.
label variable d_cow_lit_imp_07 "average milk (litres)produced per improved cow per day during their peak in 2007"

**local cows 2016**
replace d_cow_n_loc_16= r(p75) + (5 * (r(p75) - r(p25))) if d_cow_n_loc_16 > r(p75) + (5 * (r(p75) - r(p25))) & d_cow_n_loc_16!=.
label variable d_cow_n_loc_16 "number of local cows owned by the household in 2016"
sum d_cow_n_loc_16, detail

label variable d_cow_lit_loc_16 "average milk (litres)produced per local cow per day during their peak in 2016"
sum d_cow_lit_loc_16, detail
gen d_cow_lit_loc_16_out=1 if d_cow_lit_loc_16 > r(p75) + (5 * (r(p75) - r(p25))) & d_cow_lit_loc_16!=.
replace d_cow_lit_loc_16=d_cow_lit_loc_16/d_cow_n_loc_16 if d_cow_n_loc_16>1

**local cows 2007**

label variable d_cow_n_loc_07 "number of local cows owned by the household in 2007"

sum d_cow_lit_loc_07 if d_cow_lit_loc_07!=0, detail
gen d_cow_lit_loc_07_out=1 if d_cow_lit_loc_07> r(p75) + (5 * (r(p75) - r(p25))) & d_cow_lit_loc_07!=.
replace d_cow_lit_loc_07=d_cow_lit_loc_07/d_cow_n_loc_07 if d_cow_lit_loc_07_out==1
label variable d_cow_lit_loc_07 "average milk (litres)produced per local cow per day during their peak in 2007"


***dairy goats***

label variable d_got_n_imp_16 "number of improved dairy goats owned by the household in 2016"
label variable d_got_lit_imp_16 "average milk produced per improved goat in 2016"
label variable d_got_n_imp_07 "number of improved dairy goats owned by the household in 2007"
label variable d_got_lit_imp_07 "average milk produced per improved goat in 2007"

label variable d_got_n_loc_16 "number of local dairy goats owned by the household in 2016"
label variable d_got_lit_loc_16 "average milk produced per local goat in 2016"
label variable d_got_n_loc_07 "number of local dairy goats owned by the household in 2007"
label variable d_got_lit_loc_07 "average milk produced per local goat in 2007"


***Change from Baseline***

*differenced amounts per animal for each type of animal
gen loc_cow_dif_milk_y = d_cow_lit_loc_16 - d_cow_lit_loc_07 if typ_live_16_7 == 1 & typ_live_07_7 == 1

gen imp_cow_dif_milk_y = d_cow_lit_imp_16 - d_cow_lit_imp_07 if typ_live_16_8 == 1 & typ_live_07_8 == 1

gen loc_got_dif_milk_y = d_got_lit_loc_16 - d_got_lit_loc_07 if typ_live_16_11 == 1 & typ_live_07_11 == 1

gen imp_got_dif_milk_y = d_got_lit_imp_16 - d_got_lit_imp_07 if typ_live_16_12 == 1 & typ_live_07_12 == 1

*average difference across animal types
egen dif_milk_y = rmean(loc_cow_dif_milk_y imp_cow_dif_milk_y loc_got_dif_milk_y imp_got_dif_milk_y)


*percent change
gen loc_cow_milk_p_ch = loc_cow_dif_milk_y/d_cow_lit_loc_07
gen imp_cow_milk_p_ch = imp_cow_dif_milk_y/d_cow_lit_imp_07
gen loc_got_milk_p_ch = loc_got_dif_milk_y/d_got_lit_loc_07
gen imp_got_milk_p_ch = imp_got_dif_milk_y/d_got_lit_imp_07

*average percent change across animal types
egen milk_p_ch = rmean(loc_cow_milk_p_ch imp_cow_milk_p_ch loc_got_milk_p_ch imp_got_milk_p_ch)
lab var milk_p_ch "Percent Change in Milk Production"

***5. Self-reported increase in income from dairy production***

**perception on profitability**

gen milk_inc = .
replace milk_inc = 1 if per_profit_dar == 4
replace milk_inc = 2 if per_profit_dar == 5
replace milk_inc = 3 if per_profit_dar == 1
replace milk_inc = 4 if per_profit_dar == 3
replace milk_inc = 5 if per_profit_dar == 2
lab var milk_inc "Change in Milk Profit Since 2007"
 
*binary
gen milk_inc_bin = .
replace milk_inc_bin = 0 if per_profit_dar == 1 | per_profit_dar == 4 | per_profit_dar == 5
replace milk_inc_bin = 1 if per_profit_dar == 2 | per_profit_dar == 3
lab var milk_inc_bin "Increase in Milk Profit Indicator"

**Usage of tree fodder 
gen tree_fod_16 = .
replace tree_fod_16 = 0 if dar_prod == 1
replace tree_fod_16 = 1 if dar_prod == 1 & (cow_imp_fod_16 == 1 | cow_loc_fod_16 == 1 | got_imp_fod_16 == 1 | got_imp_fod_loc_16 == 1)
lab var tree_fod_16 "Tree-Based Fodder Usage 2016"

gen tree_fod_07 = .
replace tree_fod_07 = 0 if dar_prod == 1
replace tree_fod_07 = 1 if dar_prod == 1 & (cow_imp_fod_07 == 1 | cow_loc_fod_07 == 1 | got_imp_fod_07 == 1 | got_imp_fod_loc_07 == 1)
lab var tree_fod_07 "Tree-Based Fodder Usage 2007"

gen tree_fod_dif = tree_fod_16 - tree_fod_07
lab var tree_fod_dif "Differenced Usage of Tree-Based Fodder"

*=====================================*
*Asset & Expenditure Outcome Variables*
*=====================================*

***1. Differenced Asset Wealth***

***2016 Assets***
gen stove_16 = 0
replace stove_16 = 1 if asset_kitch_16_1 == 1

gen pots_16 = 0
replace pots_16 = 1 if typ_pots_16_5 == 1

gen plates_16 = 0
replace plates_16 = 1 if typ_plat_16_5 == 1 | typ_plat_16_6 == 1

gen cutlery_16 = 0
replace cutlery_16 = 1 if typ_cut_16_3 == 1 | typ_cut_16_4 == 1

gen utensils_16 = 0
replace utensils_16 = 1 if ((typ_uten_16_2 == 1 | typ_uten_16_3 == 1) & typ_uten_16_4 == 1) | typ_uten_16_5 == 1

gen bed_16 = 0
replace bed_16 = 1 if typ_bed_16_4 == 1 | typ_bed_16_5 == 1 | typ_bed_16_6 == 1

gen matress_16 = 0
replace matress_16 = 1 if typ_matres_16_5 == 1 | typ_matres_16_6 == 1

gen rug_16 = 0
replace rug_16 = 1 if asset_fur_16_3 == 1

gen sofa_16 = 0
replace sofa_16 = 1 if typ_sofa_16_11 == 1 | typ_sofa_16_10 == 1 | typ_sofa_16_8 == 1 | typ_sofa_16_4 == 1

gen table_16 = 0
replace table_16 = 1 if typ_table_16_4 == 1 | typ_table_16_5 == 1 | typ_table_16_6 == 1

gen chair_16 = 0
replace chair_16 = 1 if typ_chair_16_3 == 1 | typ_chair_16_4 == 1 | typ_chair_16_5 == 1 | typ_chair_16_6 == 1 

gen tvcab_16 = 0
replace tvcab_16 = 1 if asset_fur_16_7 == 1

gen tv_16 = 0
replace tv_16 = 1 if asset_elec_16_1 == 1

gen dish_16 = 0
replace dish_16 = 1 if asset_elec_16_2 == 1

gen dvd_16 = 0
replace dvd_16 = 1 if asset_elec_16_3 == 1

gen typ_radio_16_all = 0
forvalues i = 1/8 {
replace typ_radio_16_all = `i' if typ_radio_16_`i' == 1
}
gen radio_16 = 0
replace radio_16 = 1 if typ_radio_16_all > 1

gen typ_cphone_16_all = 0
forvalues i = 1/6 {
replace typ_cphone_16_all = `i' if typ_cphone_16_`i' == 1
}
gen cphone_16 = 0
replace cphone_16 = 1 if typ_cphone_16_all > 2

gen cpter_16 = 0
replace cpter_16 = 1 if asset_elec_16_6 == 1

gen inet_16 = 0
replace inet_16 = 1 if asset_elec_16_7 == 1

gen solar_16 = 0
replace solar_16 = 1 if asset_gen_16_1 == 1

gen gen_16 = 0
replace gen_16 = 1 if asset_gen_16_2 ==1

gen fridg_16 = 0
replace fridg_16 = 1 if asset_gen_16_3 == 1

gen iron_16 = 0
replace iron_16 = 1 if asset_gen_16_4 == 1

gen typ_lamp_16_all = 0
forvalues i = 1/8 {
replace typ_lamp_16_all = `i' if typ_lamp_16_`i' == 1
}
gen lamp_16 = 0
replace lamp_16 = 1 if typ_lamp_16_all >=4

gen case_16 = 0
replace case_16 = 1 if asset_gen_16_6 == 1

gen typ_bike_16_all = 0
forvalues i = 1/6 {
replace typ_bike_16_all = `i' if typ_bike_16_`i' == 1
}
gen bike_16 = 0
replace bike_16 = 1 if typ_bike_16_all > 1

gen mbike_16 = 0
replace mbike_16 = 1 if asset_tran_16_2 == 1

gen pveh_16 = 0
replace pveh_16 = 1 if asset_tran_16_3 == 1

gen cveh_16 = 0
replace cveh_16 = 1 if asset_tran_16_4 == 1

gen chse_16 = 0
replace chse_16 = 1 if asset_tran_16_5 == 1

gen ghse_16 = 0
replace ghse_16 = 1 if asset_tran_16_6 == 1

gen irrgp_16 = 0
replace irrgp_16 = 1 if asset_agr_16_1 == 1

gen trac_16 = 0
replace trac_16 = 1 if asset_agr_16_2 == 1

gen plou_16 = 0
replace plou_16 = 1 if typ_plou_16_2 == 1 | typ_plou_16_3 == 1

gen cart_16 = 0
replace cart_16 = 1 if asset_agr_16_4 == 1


gen typ_wbar_16_all = 0
forvalues i = 1/6 {
replace typ_wbar_16_all = `i' if typ_wbar_16_`i' == 1
}

gen wbar_16 = 0
replace wbar_16 = 1 if typ_wbar_16_all > 1

gen mill_16 = 0
replace mill_16 = 1 if asset_agr_16_6 == 1

gen fmix_16 = 0
replace fmix_16 = 1 if asset_agr_16_7 == 1

gen cutter_16 = 0
replace cutter_16 = 1 if asset_agr_16_8 == 1

gen mcan_16 = 0
replace mcan_16 = 1 if asset_agr_16_9 == 1

*most households report more than one manufactured hoe
gen hoe_16 = 0
replace hoe_16 = 1 if typ_hoe_16_4 == 1

*set breakpoint at at least one modern manufactured axe
gen axe_16 = 0
replace axe_16 = 1 if typ_axe_16_3 == 1 | typ_axe_16_4 == 1

gen sckl_16 = 0
replace sckl_16 = 1 if typ_sckl_16_3 == 1 | typ_sckl_16_4 == 1

gen shov_16 = 0
replace shov_16 = 1 if asset_agr_16_13 == 1

gen pic_16 = 0
replace pic_16 = 1 if asset_agr_16_14 == 1

gen wcan_16 = 0
replace wcan_16 = 1 if asset_agr_16_15 == 1

*most people have at lease one modern manufactured panga
gen panga_16 = 0
replace panga_16 = 1 if typ_panga_16_3 == 1 | typ_panga_16_4 == 1

gen slasher_16 = 0
replace slasher_16 = 1 if typ_slasher_16_3 == 1 | typ_slasher_16_4 == 1

gen store_16 = 0
replace store_16 = 1 if asset_agr_16_18 == 1

gen typ_live_hse_16_all = 0
forvalues i = 1/6 {
replace typ_live_hse_16_all = `i' if typ_live_hse_16_`i' == 1
}

gen live_hse_16 = 0
replace live_hse_16 = 1 if typ_live_hse_16_all >= 3

***Household Characteristics***

gen cook_fuel_hi_16 = 0
replace cook_fuel_hi_16 = 1 if cook_fuel <= 3

gen toilet_hi_16 = 0
replace toilet_hi_16 = 1 if toilet <= 2

gen floor_hi_16 = 0
replace floor_hi_16 = 1 if floor >= 4

gen walls_hi_16 = 0
replace walls_hi_16 = 1 if walls >= 11

gen roof_hi_16 = 0
replace roof_hi_16 = 1 if roof >= 7

*include electricity as is

gen water_source_hi_16 = 0
replace water_source_hi_16 = 1 if water_source <= 3

gen win_glass_16 = 0
replace win_glass_16 = 1 if oth_h_char_1 == 1

gen win_bars_16 = 0 
replace win_bars_16 = 1 if oth_h_char_2 == 1

gen door_metal_16 = 0
replace door_metal_16 = 1 if oth_h_char_3 == 1

gen gate_metal_16 = 0
replace gate_metal_16 = 1 if oth_h_char_4 == 1

gen fence_metal_16 = 0
replace fence_metal_16 = 1 if oth_h_char_5 == 1

gen water_tank_16 = 0
replace water_tank_16 = 1 if oth_h_char_6 == 1

gen bore_hole_16 = 0
replace bore_hole_16 = 1 if oth_h_char_7 == 1

gen rooms_hi_16 = 0
replace rooms_hi_16 = 1 if num_rooms > 3


***Livestock***

*simple binaries for livestock ownership by animal type:
foreach i of varlist n_loc_bull_16-n_pig_16 d_cow_n_imp_16 d_cow_n_loc_16 d_got_n_imp_16 d_got_n_loc_16{
replace `i' = 0 if `i' == .
gen `i'_bin = 0
replace `i'_bin = 1 if `i' > 0
}
rename *_16_bin *_bin_16

*indicators for higher amounts of each animal type
gen n_loc_bull_2_16 = 0
replace n_loc_bull_2_16 = 1 if n_loc_bull_16 >= 2 

gen n_imp_bull_2_16 = 0
replace n_imp_bull_2_16 = 1 if n_loc_bull_16 >= 2 

gen n_loc_oxen_2_16 = 0
replace n_loc_oxen_2_16 = 1 if n_loc_oxen_16 >= 2 

gen n_imp_oxen_2_16 = 0
replace n_imp_oxen_2_16 = 1 if n_loc_oxen_16 >= 2 

gen n_loc_steer_2_16 = 0
replace n_loc_steer_2_16 = 1 if n_loc_steer_16 >= 2 

gen n_imp_steer_2_16 = 0
replace n_imp_steer_2_16 = 1 if n_imp_steer_16 >= 2 & n_imp_steer_16 != .

gen n_loc_heif_2_16 = 0
replace n_loc_heif_2_16 = 1 if n_loc_heif_16 >= 2 & n_loc_heif_16 != .

gen n_imp_heif_2_16 = 0
replace n_imp_heif_2_16 = 1 if n_imp_heif_16 >= 2 & n_imp_heif_16 != .

gen n_imp_d_cow_2_16 = 0
replace n_imp_d_cow_2_16 = 1 if d_cow_n_imp_16 >= 2

gen n_loc_d_cow_2_16 = 0
replace n_loc_d_cow_2_16 = 1 if d_cow_n_loc_16 >= 2

*combining sheep & goats
egen n_imp_she_goa_16 =  rowtotal(n_imp_sheep_16 n_imp_goat_16 d_got_n_imp_16)

egen n_loc_she_goa_16 =  rowtotal(n_loc_sheep_16 n_loc_goat_16 d_got_n_loc_16)

gen n_imp_she_goa_hi_16 = 0
replace n_imp_she_goa_hi_16 = 1 if n_imp_she_goa_16 >= 3 

gen n_loc_she_goa_hi_16 = 0
replace n_loc_she_goa_hi_16 = 1 if n_loc_she_goa_16 >= 3 

gen n_loc_pol_hi_16 = 0
replace n_loc_pol_hi_16 = 1 if n_loc_pol_16 >= 6

gen n_imp_pol_hi_16 = 0
replace n_imp_pol_hi_16 = 1 if n_imp_pol_16 >= 10 & n_imp_pol_16 != .

gen n_pig_hi_16 = 0
replace n_pig_hi_16 = 1 if n_pig_16 >= 3 & n_pig_16 != .

***2016 Total***

local asset_bins_16 "stove_16 pots_16 plates_16 cutlery_16 utensils_16 bed_16 matress_16 rug_16 sofa_16 table_16 chair_16 tvcab_16 tv_16 dish_16 dvd_16 radio_16 cphone_16 cpter_16 inet_16 solar_16 gen_16 fridg_16 iron_16 lamp_16 case_16 bike_16 mbike_16 pveh_16 cveh_16 chse_16 ghse_16 irrgp_16 trac_16 plou_16 cart_16 wbar_16 mill_16 fmix_16 cutter_16 mcan_16 hoe_16 axe_16 sckl_16 shov_16 pic_16 wcan_16 panga_16 slasher_16 store_16 live_hse_16 cook_fuel_hi_16 toilet_hi_16 floor_hi_16 walls_hi_16 roof_hi_16 water_source_hi_16 win_glass_16 win_bars_16 door_metal_16 gate_metal_16 fence_metal_16 water_tank_16 bore_hole_16 rooms_hi_16 n_loc_bull_bin_16 n_imp_bull_bin_16 n_loc_oxen_bin_16 n_imp_oxen_bin_16 n_loc_steer_bin_16 n_imp_steer_bin_16 n_loc_heif_bin_16 n_imp_heif_bin_16 n_loc_goat_bin_16 n_imp_goat_bin_16 n_loc_sheep_bin_16 n_imp_sheep_bin_16 n_donk_bin_16 n_loc_pol_bin_16 n_imp_pol_bin_16 n_pig_bin_16 d_cow_n_imp_bin_16 d_cow_n_loc_bin_16 d_got_n_imp_bin_16 d_got_n_loc_bin_16 n_loc_bull_2_16 n_imp_bull_2_16 n_loc_oxen_2_16 n_imp_oxen_2_16 n_loc_steer_2_16 n_imp_steer_2_16 n_loc_heif_2_16 n_imp_heif_2_16 n_imp_d_cow_2_16 n_loc_d_cow_2_16 n_imp_she_goa_hi_16 n_loc_she_goa_hi_16 n_loc_pol_hi_16 n_imp_pol_hi_16 n_pig_hi_16"
global asset_bins_16 `asset_bins_16'
global asset_bins_pred `asset_bins_16'
egen asset_r_16 = rowtotal(`asset_bins_16')
lab var asset_r_16 "Raw Asset Total 2016"


***2007 Assets***

gen stove_07 = 0
replace stove_07 = 1 if asset_kitch_07_1 == 1

gen pots_07 = 0
replace pots_07 = 1 if typ_pots_07_5 == 1

gen plates_07 = 0
replace plates_07 = 1 if typ_plat_07_5 == 1 | typ_plat_07_6 == 1

gen cutlery_07 = 0
replace cutlery_07 = 1 if typ_cut_07_3 == 1 | typ_cut_07_4 == 1

gen utensils_07 = 0
replace utensils_07 = 1 if ((typ_uten_07_2 == 1 | typ_uten_07_3 == 1) & typ_uten_07_4 == 1) | typ_uten_07_5 == 1

gen bed_07 = 0
replace bed_07 = 1 if typ_bed_07_4 == 1 | typ_bed_07_5 == 1 | typ_bed_07_6 == 1

gen matress_07 = 0
replace matress_07 = 1 if typ_matres_07_5 == 1 | typ_matres_07_6 == 1

gen rug_07 = 0
replace rug_07 = 1 if asset_fur_07_3 == 1

gen sofa_07 = 0
replace sofa_07 = 1 if typ_sofa_07_11 == 1 | typ_sofa_07_10 == 1 | typ_sofa_07_8 == 1 | typ_sofa_07_4 == 1

gen table_07 = 0
replace table_07 = 1 if typ_table_07_4 == 1 | typ_table_07_5 == 1 | typ_table_07_6 == 1

gen chair_07 = 0
replace chair_07 = 1 if typ_chair_07_3 == 1 | typ_chair_07_4 == 1 | typ_chair_07_5 == 1 | typ_chair_07_6 == 1 

gen tvcab_07 = 0
replace tvcab_07 = 1 if asset_fur_07_7 == 1

gen tv_07 = 0
replace tv_07 = 1 if asset_elec_07_1 == 1

gen dish_07 = 0
replace dish_07 = 1 if asset_elec_07_2 == 1

gen dvd_07 = 0
replace dvd_07 = 1 if asset_elec_07_3 == 1

gen typ_radio_07_all = 0
forvalues i = 1/8 {
replace typ_radio_07_all = `i' if typ_radio_07_`i' == 1
}
gen radio_07 = 0
replace radio_07 = 1 if typ_radio_07_all > 1

gen typ_cphone_07_all = 0
forvalues i = 1/6 {
replace typ_cphone_07_all = `i' if typ_cphone_07_`i' == 1
}
gen cphone_07 = 0
replace cphone_07 = 1 if typ_cphone_07_all > 2

gen cpter_07 = 0
replace cpter_07 = 1 if asset_elec_07_6 == 1

gen inet_07 = 0
replace inet_07 = 1 if asset_elec_07_7 == 1

gen solar_07 = 0
replace solar_07 = 1 if asset_gen_07_1 == 1

gen gen_07 = 0
replace gen_07 = 1 if asset_gen_07_2 ==1

gen fridg_07 = 0
replace fridg_07 = 1 if asset_gen_07_3 == 1

gen iron_07 = 0
replace iron_07 = 1 if asset_gen_07_4 == 1

gen typ_lamp_07_all = 0
forvalues i = 1/8 {
replace typ_lamp_07_all = `i' if typ_lamp_07_`i' == 1
}
gen lamp_07 = 0
replace lamp_07 = 1 if typ_lamp_07_all >=4

gen case_07 = 0
replace case_07 = 1 if asset_gen_07_6 == 1

gen typ_bike_07_all = 0
forvalues i = 1/6 {
replace typ_bike_07_all = `i' if typ_bike_07_`i' == 1
}
gen bike_07 = 0
replace bike_07 = 1 if typ_bike_07_all > 1

gen mbike_07 = 0
replace mbike_07 = 1 if asset_tran_07_2 == 1

gen pveh_07 = 0
replace pveh_07 = 1 if asset_tran_07_3 == 1

gen cveh_07 = 0
replace cveh_07 = 1 if asset_tran_07_4 == 1

gen chse_07 = 0
replace chse_07 = 1 if asset_tran_07_5 == 1

gen ghse_07 = 0
replace ghse_07 = 1 if asset_tran_07_6 == 1

gen irrgp_07 = 0
replace irrgp_07 = 1 if asset_agr_07_1 == 1

gen trac_07 = 0
replace trac_07 = 1 if asset_agr_07_2 == 1

gen plou_07 = 0
replace plou_07 = 1 if typ_plou_07_2 == 1 | typ_plou_07_3 == 1

gen cart_07 = 0
replace cart_07 = 1 if asset_agr_07_4 == 1


gen typ_wbar_07_all = 0
forvalues i = 1/6 {
replace typ_wbar_07_all = `i' if typ_wbar_07_`i' == 1
}

gen wbar_07 = 0
replace wbar_07 = 1 if typ_wbar_07_all > 1

gen mill_07 = 0
replace mill_07 = 1 if asset_agr_07_6 == 1

gen fmix_07 = 0
replace fmix_07 = 1 if asset_agr_07_7 == 1

gen cutter_07 = 0
replace cutter_07 = 1 if asset_agr_07_8 == 1

gen mcan_07 = 0
replace mcan_07 = 1 if asset_agr_07_9 == 1

*most households report more than one manufactured hoe
gen hoe_07 = 0
replace hoe_07 = 1 if typ_hoe_07_4 == 1

*set breakpoint at at least one modern manufactured axe
gen axe_07 = 0
replace axe_07 = 1 if typ_axe_07_3 == 1 | typ_axe_07_4 == 1

gen sckl_07 = 0
replace sckl_07 = 1 if typ_sckl_07_3 == 1 | typ_sckl_07_4 == 1

gen shov_07 = 0
replace shov_07 = 1 if asset_agr_07_13 == 1

gen pic_07 = 0
replace pic_07 = 1 if asset_agr_07_14 == 1

gen wcan_07 = 0
replace wcan_07 = 1 if asset_agr_07_15 == 1

*most people have at lease one modern manufactured panga
gen panga_07 = 0
replace panga_07 = 1 if typ_panga_07_3 == 1 | typ_panga_07_4 == 1

gen slasher_07 = 0
replace slasher_07 = 1 if typ_slasher_07_3 == 1 | typ_slasher_07_4 == 1

gen store_07 = 0
replace store_07 = 1 if asset_agr_07_18 == 1

gen typ_live_hse_07_all = 0
forvalues i = 1/6 {
replace typ_live_hse_07_all = `i' if typ_live_hse_07_`i' == 1
}

gen live_hse_07 = 0
replace live_hse_07 = 1 if typ_live_hse_07_all >= 3

***Household Characteristics***

gen cook_fuel_hi_07 = 0
replace cook_fuel_hi_07 = 1 if cook_fuel_07 <= 3

gen toilet_hi_07 = 0
replace toilet_hi_07 = 1 if toilet_07 <= 2

gen floor_hi_07 = 0
replace floor_hi_07 = 1 if floor_07 >= 4

gen walls_hi_07 = 0
replace walls_hi_07 = 1 if walls_07 >= 11

gen roof_hi_07 = 0
replace roof_hi_07 = 1 if roof_07 >= 7

*include electricity as is

gen water_source_hi_07 = 0
replace water_source_hi_07 = 1 if water_source_07 <= 3

gen win_glass_07 = 0
replace win_glass_07 = 1 if oth_h_char_07_1 == 1

gen win_bars_07 = 0 
replace win_bars_07 = 1 if oth_h_char_07_2 == 1

gen door_metal_07 = 0
replace door_metal_07 = 1 if oth_h_char_07_3 == 1

gen gate_metal_07 = 0
replace gate_metal_07 = 1 if oth_h_char_07_4 == 1

gen fence_metal_07 = 0
replace fence_metal_07 = 1 if oth_h_char_07_5 == 1

gen water_tank_07 = 0
replace water_tank_07 = 1 if oth_h_char_07_6 == 1

gen bore_hole_07 = 0
replace bore_hole_07 = 1 if oth_h_char_07_7 == 1

gen rooms_hi_07 = 0
replace rooms_hi_07 = 1 if num_rooms_07 > 3


***Livestock***

*simple binaries for livestock ownership by animal type:
foreach i of varlist n_loc_bull_07-n_pig_07 d_cow_n_imp_07 d_cow_n_loc_07 d_got_n_imp_07 d_got_n_loc_07{
replace `i' = 0 if `i' == .
gen `i'_bin = 0
replace `i'_bin = 1 if `i' > 0
}
rename *_07_bin *_bin_07

*indicators for higher amounts of each animal type
gen n_loc_bull_2_07 = 0
replace n_loc_bull_2_07 = 1 if n_loc_bull_07 >= 2 

gen n_imp_bull_2_07 = 0
replace n_imp_bull_2_07 = 1 if n_loc_bull_07 >= 2 

gen n_loc_oxen_2_07 = 0
replace n_loc_oxen_2_07 = 1 if n_loc_oxen_07 >= 2 

gen n_imp_oxen_2_07 = 0
replace n_imp_oxen_2_07 = 1 if n_loc_oxen_07 >= 2 

gen n_loc_steer_2_07 = 0
replace n_loc_steer_2_07 = 1 if n_loc_steer_07 >= 2 

gen n_imp_steer_2_07 = 0
replace n_imp_steer_2_07 = 1 if n_imp_steer_07 >= 2 & n_imp_steer_07 != .

gen n_loc_heif_2_07 = 0
replace n_loc_heif_2_07 = 1 if n_loc_heif_07 >= 2 & n_loc_heif_07 != .

gen n_imp_heif_2_07 = 0
replace n_imp_heif_2_07 = 1 if n_imp_heif_07 >= 2 & n_imp_heif_07 != .

gen n_imp_d_cow_2_07 = 0
replace n_imp_d_cow_2_07 = 1 if d_cow_n_imp_07 >= 2

gen n_loc_d_cow_2_07 = 0
replace n_loc_d_cow_2_07 = 1 if d_cow_n_loc_07 >= 2

*combining sheep & goats
egen n_imp_she_goa_07 =  rowtotal(n_imp_sheep_07 n_imp_goat_07 d_got_n_imp_07)

egen n_loc_she_goa_07 =  rowtotal(n_loc_sheep_07 n_loc_goat_07 d_got_n_loc_07)

gen n_imp_she_goa_hi_07 = 0
replace n_imp_she_goa_hi_07 = 1 if n_imp_she_goa_07 >= 3 

gen n_loc_she_goa_hi_07 = 0
replace n_loc_she_goa_hi_07 = 1 if n_loc_she_goa_07 >= 3 

gen n_loc_pol_hi_07 = 0
replace n_loc_pol_hi_07 = 1 if n_loc_pol_07 >= 6

gen n_imp_pol_hi_07 = 0
replace n_imp_pol_hi_07 = 1 if n_imp_pol_07 >= 10 & n_imp_pol_07 != .

gen n_pig_hi_07 = 0
replace n_pig_hi_07 = 1 if n_pig_07 >= 3 & n_pig_07 != .

***2007 Total***

local asset_bins_07 "stove_07 pots_07 plates_07 cutlery_07 utensils_07 bed_07 matress_07 rug_07 sofa_07 table_07 chair_07 tvcab_07 tv_07 dish_07 dvd_07 radio_07 cphone_07 cpter_07 inet_07 solar_07 gen_07 fridg_07 iron_07 lamp_07 case_07 bike_07 mbike_07 pveh_07 cveh_07 chse_07 irrgp_07 trac_07 plou_07 cart_07 wbar_07 mill_07 fmix_07 cutter_07 mcan_07 hoe_07 axe_07 sckl_07 shov_07 pic_07 wcan_07 panga_07 slasher_07 store_07 live_hse_07 cook_fuel_hi_07 toilet_hi_07 floor_hi_07 walls_hi_07 roof_hi_07 water_source_hi_07 win_glass_07 win_bars_07 door_metal_07 gate_metal_07 fence_metal_07 water_tank_07 bore_hole_07 rooms_hi_07 n_loc_bull_bin_07 n_imp_bull_bin_07 n_loc_oxen_bin_07 n_imp_oxen_bin_07 n_loc_steer_bin_07 n_imp_steer_bin_07 n_loc_heif_bin_07 n_imp_heif_bin_07 n_loc_goat_bin_07 n_imp_goat_bin_07 n_loc_sheep_bin_07 n_imp_sheep_bin_07 n_donk_bin_07 n_loc_pol_bin_07 n_imp_pol_bin_07 n_pig_bin_07 d_cow_n_imp_bin_07 d_cow_n_loc_bin_07 d_got_n_imp_bin_07 d_got_n_loc_bin_07 n_loc_bull_2_07 n_imp_bull_2_07 n_loc_oxen_2_07 n_imp_oxen_2_07 n_loc_steer_2_07 n_imp_steer_2_07 n_loc_heif_2_07 n_imp_heif_2_07 n_imp_d_cow_2_07 n_loc_d_cow_2_07 n_imp_she_goa_hi_07 n_loc_she_goa_hi_07 n_loc_pol_hi_07 n_imp_pol_hi_07 n_pig_hi_07"
global asset_bins_07 `asset_bins_07'
egen asset_r_07 = rowtotal(`asset_bins_07')
lab var asset_r_07 "Raw Asset Total 2007"

***Differenced Value***

gen dif_asset_r = asset_r_16 - asset_r_07
lab var dif_asset_r "Differenced Raw Asset Total"

***PCA Analysis of Assets***
alpha $asset_bins_07, item

foreach v of global asset_bins_16 {
local v7 : subinstr local v "_16" "_07"
gen `v'_pos = `v' - `v7'
replace `v'_pos = 0 if `v'_pos < 0 
}

global assets_pos_dif "stove_16_pos pots_16_pos plates_16_pos cutlery_16_pos utensils_16_pos bed_16_pos matress_16_pos rug_16_pos sofa_16_pos table_16_pos chair_16_pos tvcab_16_pos tv_16_pos dish_16_pos dvd_16_pos radio_16_pos cphone_16_pos cpter_16_pos inet_16_pos solar_16_pos gen_16_pos fridg_16_pos iron_16_pos lamp_16_pos case_16_pos bike_16_pos mbike_16_pos pveh_16_pos cveh_16_pos chse_16_pos ghse_16_pos irrgp_16_pos trac_16_pos plou_16_pos cart_16_pos wbar_16_pos mill_16_pos fmix_16_pos cutter_16_pos mcan_16_pos hoe_16_pos axe_16_pos sckl_16_pos shov_16_pos pic_16_pos wcan_16_pos panga_16_pos slasher_16_pos store_16_pos live_hse_16_pos cook_fuel_hi_16_pos toilet_hi_16_pos floor_hi_16_pos walls_hi_16_pos roof_hi_16_pos water_source_hi_16_pos win_glass_16_pos win_bars_16_pos door_metal_16_pos gate_metal_16_pos fence_metal_16_pos water_tank_16_pos bore_hole_16_pos rooms_hi_16_pos n_loc_bull_bin_16_pos n_imp_bull_bin_16_pos n_loc_oxen_bin_16_pos n_imp_oxen_bin_16_pos n_loc_steer_bin_16_pos n_imp_steer_bin_16_pos n_loc_heif_bin_16_pos n_imp_heif_bin_16_pos n_loc_goat_bin_16_pos n_imp_goat_bin_16_pos n_loc_sheep_bin_16_pos n_imp_sheep_bin_16_pos n_donk_bin_16_pos n_loc_pol_bin_16_pos n_imp_pol_bin_16_pos n_pig_bin_16_pos d_cow_n_imp_bin_16_pos d_cow_n_loc_bin_16_pos d_got_n_imp_bin_16_pos d_got_n_loc_bin_16_pos n_loc_bull_2_16_pos n_imp_bull_2_16_pos n_loc_oxen_2_16_pos n_imp_oxen_2_16_pos n_loc_steer_2_16_pos n_imp_steer_2_16_pos n_loc_heif_2_16_pos n_imp_heif_2_16_pos n_imp_d_cow_2_16_pos n_loc_d_cow_2_16_pos n_imp_she_goa_hi_16_pos n_loc_she_goa_hi_16_pos n_loc_pol_hi_16_pos n_imp_pol_hi_16_pos n_pig_hi_16_pos"


alpha $assets_pos_dif, item

*remove assets with negative correlations:
global assets_pos_dif: subinstr global assets_pos_dif "bed_16_pos" ""
global assets_pos_dif: subinstr global assets_pos_dif "n_imp_heif_bin_16_pos" ""
global assets_pos_dif: subinstr global assets_pos_dif "n_pig_bin_16_pos" ""
global assets_pos_dif: subinstr global assets_pos_dif "n_imp_sheep_bin_16_pos" ""

tetrachoric $assets_pos_dif, notable posdef
matrix C = r(corr)
matrix symeigen eigenvectors eigenvalues = C
pcamat C, n(2860) components(1)

predict dif_a_pca
label var dif_a_pca "PCA-Weighted Increase in Assets"


foreach v of global asset_bins_16 {
local v7 : subinstr local v "_16" "_07"
gen `v'_dif = `v' - `v7'
}

global assets_dif "stove_16_dif pots_16_dif plates_16_dif cutlery_16_dif utensils_16_dif bed_16_dif matress_16_dif rug_16_dif sofa_16_dif table_16_dif chair_16_dif tvcab_16_dif tv_16_dif dish_16_dif dvd_16_dif radio_16_dif cphone_16_dif cpter_16_dif inet_16_dif solar_16_dif gen_16_dif fridg_16_dif iron_16_dif lamp_16_dif case_16_dif bike_16_dif mbike_16_dif pveh_16_dif cveh_16_dif chse_16_dif ghse_16_dif irrgp_16_dif trac_16_dif plou_16_dif cart_16_dif wbar_16_dif mill_16_dif fmix_16_dif cutter_16_dif mcan_16_dif hoe_16_dif axe_16_dif sckl_16_dif shov_16_dif pic_16_dif wcan_16_dif panga_16_dif slasher_16_dif store_16_dif live_hse_16_dif cook_fuel_hi_16_dif toilet_hi_16_dif floor_hi_16_dif walls_hi_16_dif roof_hi_16_dif water_source_hi_16_dif win_glass_16_dif win_bars_16_dif door_metal_16_dif gate_metal_16_dif fence_metal_16_dif water_tank_16_dif bore_hole_16_dif rooms_hi_16_dif n_loc_bull_bin_16_dif n_imp_bull_bin_16_dif n_loc_oxen_bin_16_dif n_imp_oxen_bin_16_dif n_loc_steer_bin_16_dif n_imp_steer_bin_16_dif n_loc_heif_bin_16_dif n_imp_heif_bin_16_dif n_loc_goat_bin_16_dif n_imp_goat_bin_16_dif n_loc_sheep_bin_16_dif n_imp_sheep_bin_16_dif n_donk_bin_16_dif n_loc_pol_bin_16_dif n_imp_pol_bin_16_dif n_pig_bin_16_dif d_cow_n_imp_bin_16_dif d_cow_n_loc_bin_16_dif d_got_n_imp_bin_16_dif d_got_n_loc_bin_16_dif n_loc_bull_2_16_dif n_imp_bull_2_16_dif n_loc_oxen_2_16_dif n_imp_oxen_2_16_dif n_loc_steer_2_16_dif n_imp_steer_2_16_dif n_loc_heif_2_16_dif n_imp_heif_2_16_dif n_imp_d_cow_2_16_dif n_loc_d_cow_2_16_dif n_imp_she_goa_hi_16_dif n_loc_she_goa_hi_16_dif n_loc_pol_hi_16_dif n_imp_pol_hi_16_dif n_pig_hi_16_dif"

alpha $assets_dif, item

global assets_dif: subinstr global assets_dif "n_imp_steer_bin_16_dif" ""



pca $assets_dif, components(1)

predict dif_a_pca_neg

sum dif_a_pca_neg, detail
replace dif_a_pca_neg = `r(p75)' + (5 * (`r(p75)' - `r(p25)')) if dif_a_pca_neg > `r(p75)' + (5 * (`r(p75)' - `r(p25)'))
lab var dif_a_pca_neg "PCA-Weighted Differenced Assets"




***2. Single Difference Consumption Expenditure***

*Adjusted Household Size for Per Capita Consumption Calculations
gen hh_size_adj = (num_adult + (num_child * .33))^.9
lab var hh_size_adj "HH size adjusted for economies of scale"

***Food Consumption Expenditure***

gen ugali_price_kg = carb_consumption1_carb_t_cost/carb_consumption1_carb_quan if (strpos(carb_consumption1_carb_name, "our") | strpos(carb_consumption1_carb_name, "gali")) & (strpos(carb_consumption1_carb_unit, "ilogram") | strpos(carb_consumption1_carb_unit, "kg") | strpos(carb_consumption1_carb_unit, "Kg"))
summarize ugali_price_kg, detail
*median price per kilo of Ugali is 40 KSH

gen ugali_price_tin = carb_consumption1_carb_t_cost/carb_consumption1_carb_quan if (strpos(carb_consumption1_carb_name, "our") | strpos(carb_consumption1_carb_name, "gali")) & (strpos(carb_consumption1_carb_unit, "Tins") | strpos(carb_consumption1_carb_unit, "tins"))
summarize ugali_price_tin, detail
*median price per tin is 50

gen ugali_price_gor = carb_consumption1_carb_t_cost/carb_consumption1_carb_quan if (strpos(carb_consumption1_carb_name, "our") | strpos(carb_consumption1_carb_name, "gali")) & strpos(carb_consumption1_carb_unit, "goro")
summarize ugali_price_gor, detail
*median price per gorogoro 57

*replace outliers with quantity times median price
replace carb_consumption1_carb_t_cost = 560 if farmer_code == "M25"
replace carb_consumption1_carb_t_cost = 480 if farmer_code == "M475"

gen meat_kg = 0
replace meat_kg = 1 if strpos(meat_consumption1_meat_name, "eat") | strpos(meat_consumption1_meat_name, "eef")

gen meat_price = meat_consumption1_meat_t_cost/meat_consumption1_meat_quan if meat_kg == 1
summarize meat_price, detail
*median meat price per kg is 300 KSH

gen milk_price = meat_consumption1_meat_t_cost/meat_consumption1_meat_quan if strpos(meat_consumption1_meat_unit, "up")
summarize milk_price, detail
*median milk price is 20 KSH

gen milk2_cups_pr = meat_consumption2_meat_t_cost/meat_consumption2_meat_quan if strpos(meat_consumption2_meat_unit, "up")

*these values were off by an order of 10, replace with quantity time median price
replace meat_consumption1_meat_t_cost = 600 if farmer_code == "M652"
replace meat_consumption1_meat_t_cost = 980 if farmer_code == "W1049"
replace meat_consumption1_meat_t_cost = 900 if farmer_code == "W391"
replace meat_consumption2_meat_t_cost = 140 if farmer_code == "M57"
replace meat_consumption3_meat_t_cost = 150 if farmer_code == "M824"

gen ind_veg_pr = fruit_consumption1_fruit_t_cos/fruit_consumption1_fruit_quan if strpos(fruit_consumption1_fruit_name, "nous v") & strpos(fruit_consumption1_fruit_unit, "undles")
summarize ind_veg_pr, detail
*median price 10 per bundle

*replace with quantity times median price
replace fruit_consumption1_fruit_t_cos = 420 if farmer_code == "W285"
replace fruit_consumption1_fruit_t_cos = 140 if farmer_code == "W1510"


***Calculate Food Consumption Totals***

egen carb_t_cost = rowtotal(carb_consumption1_carb_t_cost carb_consumption2_carb_t_cost carb_consumption3_carb_t_cost carb_consumption4_carb_t_cost carb_consumption5_carb_t_cost carb_consumption6_carb_t_cost carb_consumption7_carb_t_cost carb_consumption8_carb_t_cost)
egen pulse_t_cost = rowtotal(pulse_consumption1_pulse_t_cos pulse_consumption2_pulse_t_cos pulse_consumption3_pulse_t_cos pulse_consumption4_pulse_t_cos pulse_consumption5_pulse_t_cos)
egen meat_t_cost = rowtotal(meat_consumption1_meat_t_cost meat_consumption2_meat_t_cost meat_consumption3_meat_t_cost meat_consumption4_meat_t_cost meat_consumption5_meat_t_cost meat_consumption6_meat_t_cost)
egen fruit_t_cost = rowtotal(fruit_consumption1_fruit_t_cos fruit_consumption2_fruit_t_cos fruit_consumption3_fruit_t_cos fruit_consumption4_fruit_t_cos fruit_consumption5_fruit_t_cos fruit_consumption6_fruit_t_cos fruit_consumption7_fruit_t_cos fruit_consumption8_fruit_t_cos fruit_consumption9_fruit_t_cos fruit_consumption10_fruit_t_co fruit_consumption11_fruit_t_co)
egen bev_t_cost = rowtotal(bev_consumption1_bev_t_cost bev_consumption2_bev_t_cost bev_consumption3_bev_t_cost)
egen oth_f_t_cost = rowtotal(other_food_consump1_oth_f_t_co other_food_consump2_oth_f_t_co other_food_consump3_oth_f_t_co)

*compute daily value of weekly food consumption expenditure
egen hh_food_exp_wk = rowtotal(carb_t_cost pulse_t_cost meat_t_cost fruit_t_cost bev_t_cost oth_f_t_cost)
gen hh_food_exp_d = hh_food_exp_wk/7

gen pc_food_exp_d = hh_food_exp_d/hh_size
gen adj_pc_food_exp = hh_food_exp_d/hh_size_adj


***Household Monthly Expenditures***

*debt has negative values. I think they should just be turned positive
replace debt_exp = debt_exp*(-1) if debt_exp < 0

foreach var of varlist pub_tran_exp-oth_an_exp {
summarize `var' if `var' > 0, detail
gen `var'_out = 1 if `var' > `r(p75)' + (5 * (`r(p75)' - `r(p25)'))
replace `var' = `r(p75)' + (5 * (`r(p75)' - `r(p25)')) if `var'_out == 1
replace `var' = `var' * (-1) if `var' < 0 
}

*compute daily value of monthly expenditures
egen hh_month_exp = rowtotal(pub_tran_exp pri_tran_exp cook_fuel_exp gas_exp elec_exp soap_exp bea_prod_exp hair_exp milling_exp mobile_exp toba_exp ent_exp gamb_exp mem_fees_exp donation_exp water_exp)
gen hh_month_exp_d = hh_month_exp/7
lab var hh_month_exp_d "daily cash value of regular expenditures"

*compute daily value of annual expenditures
egen hh_ann_exp = rowtotal(cloth_exp fest_exp plate_exp clean_exp cd_dvd_exp ent_equip_exp linen_exp furn_exp livestock_exp farm_equip_exp bike_veh_exp build_mat_exp educ_exp health_exp house_rent_exp debt_exp fine_exp sav_exp oth_an_exp)
gen hh_ann_exp_d = hh_ann_exp/365
lab var hh_ann_exp_d "daily cash value of non-regular expenditures"

*compute daily value of total HH expenditures
egen daily_hh_exp = rowtotal(hh_month_exp_d hh_ann_exp_d hh_food_exp_d)
lab var daily_hh_exp "daily HH expenditure"

*convert to PPP: 44.29 KSH to 1 USD as of 2015
gen daily_ppp_exp = daily_hh_exp/43.849
lab var daily_ppp_exp "daily HH expenditure adjusted for PPP"

*daily HH expenditure in ppp log
gen daily_ppp_exp_log = log(daily_ppp_exp)

*compute per capita expenditure in PPP
gen d_ppp_exp_pc = daily_ppp_exp/hh_size_adj
lab var d_ppp_exp_pc "daily per capita expenditure adjusted for PPP & HH econ of scale"

*log of per capita expenditure in PPP
gen d_ppp_exp_pc_log = log(d_ppp_exp_pc)
lab var d_ppp_exp_pc_log "log of PPP adjusted daily per capita expenditure" 

*per capita expenditure in KSH
gen d_ksh_exp_pc = daily_hh_exp/hh_size_adj
lab var d_ksh_exp_pc "daily per capita expenditure in KSH adjusted for HH econ of scale"

*log of per capita expenditure in KSH
gen d_ksh_exp_pc_log = log(d_ksh_exp_pc)
lab var d_ksh_exp_pc_log  "log of KSH daily per capita expenditure"

*proportion of HH expenditure spent on food
gen prop_HH_exp_f = hh_food_exp_d/daily_hh_exp
lab var prop_HH_exp_f "proportion of HH expenditure on food"


***Single Difference Adjusted Per Capita Consumption Expenditure Variable in PPP
gen sig_ce = d_ppp_exp_pc

*trim outliers
sum sig_ce, detail
replace sig_ce = `r(p75)' + (5 * (`r(p75)' - `r(p25)')) if sig_ce > `r(p75)' + (5 * (`r(p75)' - `r(p25)'))
lab var sig_ce "Household Consumption Expenditure 2016

*===============*
*Primary Outcome*
*===============*

***Differenced Predicted Expenditure***

global asset_bins_pred: subinstr global asset_bins_pred "n_imp_bull_2_16" ""
global asset_bins_pred: subinstr global asset_bins_pred "n_imp_oxen_2_16" ""
global asset_bins_pred: subinstr global asset_bins_pred "inet_16" ""
global asset_bins_pred: subinstr global asset_bins_pred "cpter_16" ""
global asset_bins_pred: subinstr global asset_bins_pred "cphone_16" ""
global asset_bins_pred: subinstr global asset_bins_pred "dvd_16" ""

stepwise, pr(0.2): reg daily_ppp_exp $asset_bins_pred, nocon
est store exp_pred_a


*program for generating weighted assets
*had to install indeplist and dm79 packages to do this
indeplist, local
global weight_names
foreach i of local X {
global weight_names $weight_names `i'_w
}
global weight_names: subinstr global weight_names "_16" "", all
global assets_16 `X'
global assets_07: subinstr global assets_16 "_16" "_07", all
global assets_wt_16: subinstr global weight_names "_w" "_wt_16", all
global assets_wt_07: subinstr global weight_names "_w" "_wt_07", all

*set matsize 3000
*matrix asset_coef = e(b)
*mata : st_matrix("coef_sum", rowsum(st_matrix("asset_coef")))
*scalar coef_col_tot = coef_sum[1,1]
*matrix asset_w = asset_coef / coef_col_tot

*svmat2 asset_w, names("$weight_names")
*foreach i of global weight_names {
*replace `i' = `i'[_n-1] if `i' == .
*}
*mkmat $weight_names, matrix(weight_cols)

*mkmat $assets_16 , matrix(asset_vals_16)
*mkmat $assets_07, matrix(asset_vals_07)
*mata : st_matrix("assets_w_16", st_matrix("asset_vals_16") :* st_matrix("weight_cols"))
*mata : st_matrix("assets_w_07", st_matrix("asset_vals_07") :* st_matrix("weight_cols"))

*svmat2 assets_w_16, names("$assets_wt_16")
*svmat2 assets_w_07, names("$assets_wt_07")

*reg daily_ppp_exp $assets_wt_16
*predict pre_ce_a_16 

*reg daily_ppp_exp $assets_wt_07
*predict pre_ce_a_07 

*gen dif_pre_ce_a = pre_ce_a_16 - pre_ce_a_07



***Adding in other predictors***
*think about education specification: highest number of years of education for employed member or any member? 
replace y_edu_head = Oth_HH_Mem0_educat_mem if y_edu_head==.

gen pvt_sch = 0
foreach i of num 1/16 18 {
	foreach j of num 5/8 11 14 {
	replace pvt_sch = 1 if Oth_HH_Mem`i'_sch_mem_type == `j'
	}
}

gen no_edu_15 = 0
foreach i of num 1/16 {
replace no_edu_15 = 1 if Oth_HH_Mem`i'_age_mem > 15 & Oth_HH_Mem`i'_educat_mem == 0
}

global exp_preds "hh_size y_edu_head max_edu_hh land_bl fem_headed pvt_sch"

reg daily_ppp_exp $exp_preds

reg daily_ppp_exp_log $exp_preds


***full model with assets and other predictors***

reg daily_ppp_exp $assets_16 $exp_preds, nocons
est store exp_pred_b

*program for generating weighted assets
indeplist, local
global weight_names
foreach i of local X {
global weight_names $weight_names `i'_w
}
global weight_names: subinstr global weight_names "_16" "", all
global assets_16 `X'
global assets_07: subinstr global assets_16 "_16" "_07", all
global assets_wt_16: subinstr global weight_names "_w" "_wt_16", all
global assets_wt_07: subinstr global weight_names "_w" "_wt_07", all

set matsize 3000
matrix asset_coef = e(b)
mata : st_matrix("coef_sum", rowsum(st_matrix("asset_coef")))
scalar coef_col_tot = coef_sum[1,1]
matrix asset_w = asset_coef / coef_col_tot

svmat2 asset_w, names("$weight_names")
foreach i of global weight_names {
replace `i' = `i'[_n-1] if `i' == .
}
mkmat $weight_names, matrix(weight_cols)

mkmat $assets_16 , matrix(asset_vals_16)
mkmat $assets_07, matrix(asset_vals_07)
mata : st_matrix("assets_w_16", st_matrix("asset_vals_16") :* st_matrix("weight_cols"))
mata : st_matrix("assets_w_07", st_matrix("asset_vals_07") :* st_matrix("weight_cols"))

svmat2 assets_w_16, names("$assets_wt_16")
svmat2 assets_w_07, names("$assets_wt_07")

reg daily_ppp_exp $assets_wt_16
predict pre_ce_16 

summarize pre_ce_16 if pre_ce_16 > 0
replace pre_ce_16 = `r(min)' if pre_ce_16 < `r(min)'

summarize pre_ce_16, detail
replace pre_ce_16 = `r(p75)' + (5 * (`r(p75)' - `r(p25)')) if pre_ce_16 > `r(p75)' + (5 * (`r(p75)' - `r(p25)'))
lab var pre_ce_16 "Predicted Household Consumption Expenditure 2016"

reg daily_ppp_exp $assets_wt_07
predict pre_ce_07 

summarize pre_ce_07 if pre_ce_07 > 0
replace pre_ce_07 = `r(min)' if pre_ce_07 < `r(min)'

summarize pre_ce_07, detail
replace pre_ce_07 = `r(p75)' + (5 * (`r(p75)' - `r(p25)')) if pre_ce_07 > `r(p75)' + (5 * (`r(p75)' - `r(p25)'))
lab var pre_ce_07 "Predicted Household Consumption Expenditure 2007"

gen dif_pre_ce = pre_ce_16 - pre_ce_07
lab var dif_pre_ce "Differenced Predicted Household Expenditure"

**Divide by adjusted household size
gen pre_ce_pc_16 = pre_ce_16 / hh_size_adj
summarize pre_ce_pc_16, detail
replace pre_ce_pc_16 = `r(p75)' + (5 * (`r(p75)' - `r(p25)')) if pre_ce_pc_16 > `r(p75)' + (5 * (`r(p75)' - `r(p25)'))
lab var pre_ce_pc_16 "Predicted Expenditure Per Capita 2016"

gen pre_ce_pc_07 = pre_ce_07 / hh_size_adj
summarize pre_ce_pc_07, detail
replace pre_ce_pc_07 = `r(p75)' + (5 * (`r(p75)' - `r(p25)')) if pre_ce_pc_07 > `r(p75)' + (5 * (`r(p75)' - `r(p25)'))
lab var pre_ce_pc_07 "Predicted Expenditure Per Capita 2007"

gen dif_pre_ce_pc = pre_ce_pc_16 - pre_ce_pc_07
lab var dif_pre_ce_pc "Differenced Predicted Expenditure Per Capita"


**Create logged variables
gen ln_pre_ce_07 = ln(pre_ce_07)
gen ln_pre_ce_16 = ln(pre_ce_16)
gen ln_dif_pre_ce = ln_pre_ce_16 - ln_pre_ce_07

gen ln_aftr_dif_pre_ce = ln(dif_pre_ce + 50)



*hh_poor
*< 1.90 ppp predicted daily per capita expendicture
gen hh_poor = 0
replace hh_poor = 1 if pre_ce_pc_07 < 1.9
*only 23 observations. Should change cut-off?



** experiment with log-level model

reg daily_ppp_exp_log $asset_bins_pred $exp_preds, nocon

*program for generating weighted assets
indeplist, local
global weight_names
foreach i of local X {
global weight_names $weight_names `i'_wlog
}
global weight_names: subinstr global weight_names "_16" "", all
global assets_16 `X'
global assets_07: subinstr global assets_16 "_16" "_07", all
global assets_wt_16: subinstr global weight_names "_w" "_wt_16", all
global assets_wt_07: subinstr global weight_names "_w" "_wt_07", all

set matsize 3000
matrix asset_coef = e(b)
mata : st_matrix("coef_sum", rowsum(st_matrix("asset_coef")))
scalar coef_col_tot = coef_sum[1,1]
matrix asset_w = asset_coef / coef_col_tot

svmat2 asset_w, names("$weight_names")
foreach i of global weight_names {
replace `i' = `i'[_n-1] if `i' == .
}
mkmat $weight_names, matrix(weight_cols)

mkmat $assets_16 , matrix(asset_vals_16)
mkmat $assets_07, matrix(asset_vals_07)
mata : st_matrix("assets_w_16", st_matrix("asset_vals_16") :* st_matrix("weight_cols"))
mata : st_matrix("assets_w_07", st_matrix("asset_vals_07") :* st_matrix("weight_cols"))

svmat2 assets_w_16, names("$assets_wt_16")
svmat2 assets_w_07, names("$assets_wt_07")

reg daily_ppp_exp_log $assets_wt_16
predict pre_ce_log_16 

gen pre_ce_16_ln = ln(pre_ce_16)

gen pre_ce_log_16_exp = exp(pre_ce_log_16)

reg daily_ppp_exp_log $assets_wt_07
predict pre_ce_log_07

gen dif_pre_ce_log = pre_ce_log_16 - pre_ce_log_07


*dummy for above 3rd quartile of baseline expenditure
gen pre_ce_75_07 = 0
sum pre_ce_07, detail
replace pre_ce_75_07 = 1 if pre_ce_07 > `r(p75)'

*dummy for above median of baseline expenditurea
gen pre_ce_50_07 = 0
sum pre_ce_07, detail
replace pre_ce_50_07 = 1 if pre_ce_07 > `r(p50)'

*dummy for above the 90th percentile
gen pre_ce_90_07 = 0
sum pre_ce_07, detail
replace pre_ce_90_07 = 1 if pre_ce_07 > `r(p90)'

*dummy for below the 25th percentile
gen pre_ce_25_07 = 0
sum pre_ce_07, detail
replace pre_ce_25_07 = 1 if pre_ce_07 < `r(p25)'

*dummy for below the 10th percentile
gen pre_ce_10_07 = 0
sum pre_ce_07, detail
replace pre_ce_10_07 = 1 if pre_ce_07 < `r(p10)'



*=======================*
*Other Outcome Variables*
*=======================*


***3. Adapted Coping Strategies Index***

*assign points for experiencing shock at different severities
gen exp_shock = 0
replace exp_shock = 2 if exp_shock_1 == 2 | exp_shock_2 == 2 | exp_shock_3 == 2 | exp_shock_4 == 2 
replace exp_shock = 4 if exp_shock_1 == 3 | exp_shock_2 == 3 | exp_shock_3 == 3 | exp_shock_4 == 3 
replace exp_shock = 8 if exp_shock_1 == 4 | exp_shock_2 == 4 | exp_shock_3 == 4 | exp_shock_4 == 4 

gen credit = 0
replace credit = 2 if cop_shock_1_1 == 1 | cop_shock_2_1 == 1 | cop_shock_3_1 == 1 | cop_shock_4_1 == 1

gen red_meals = 0
replace red_meals = 2 if cop_shock_1_2 == 1 | cop_shock_2_2 == 1 | cop_shock_3_2 == 1 | cop_shock_4_2 == 1

gen lim_port = 0
replace lim_port = 1 if cop_shock_1_3 == 1 | cop_shock_2_3 == 1 | cop_shock_3_3 == 1 | cop_shock_4_3 == 1

gen day_fast = 0
replace day_fast = 4 if cop_shock_1_4 == 1 | cop_shock_2_4 == 1 | cop_shock_3_4 == 1 | cop_shock_4_4 == 1

gen rest_adult = 0
replace rest_adult = 2 if cop_shock_1_5 == 1 | cop_shock_2_5 == 1 | cop_shock_3_5 == 1 | cop_shock_4_5 == 1

gen rest_child = 0
replace rest_child = 4 if cop_shock_1_6 == 1 | cop_shock_2_6 == 1 | cop_shock_3_6 == 1 | cop_shock_4_6 == 1

gen sub_cheap = 0
replace sub_cheap = 1 if cop_shock_1_7 == 1 | cop_shock_2_7 == 1 | cop_shock_3_7 == 1 | cop_shock_4_7 == 1

gen mod_cook = 0
replace mod_cook = 1 if cop_shock_1_8 == 1 | cop_shock_2_8 == 1 | cop_shock_3_8 == 1 | cop_shock_4_8 == 1

gen sell_asset = 0
replace sell_asset = 4 if cop_shock_1_9 == 1 | cop_shock_2_9 == 1 | cop_shock_3_9 == 1 | cop_shock_4_9 == 1

gen bor_neigh = 0
replace bor_neigh = 2 if cop_shock_1_10 == 1 | cop_shock_2_10 == 1 | cop_shock_3_10 == 1 | cop_shock_4_10 == 1

gen remitt = 0
replace remitt = 2 if cop_shock_1_11 == 1 | cop_shock_2_11 == 1 | cop_shock_3_11 == 1 | cop_shock_4_11 == 1

gen begging = 0
replace begging = 4 if cop_shock_1_12 == 1 | cop_shock_2_12 == 1 | cop_shock_3_12 == 1 | cop_shock_4_12 == 1

gen eat_else = 0
replace eat_else = 2 if cop_shock_1_13 == 1 | cop_shock_2_13 == 1 | cop_shock_3_13 == 1 | cop_shock_4_13 == 1

gen gath_wild = 0
replace gath_wild = 2 if cop_shock_1_14 == 1 | cop_shock_2_14 == 1 | cop_shock_3_14 == 1 | cop_shock_4_14 == 1


egen cop_stra = rowtotal(exp_shock credit red_meals lim_port day_fast rest_adult rest_child sub_cheap mod_cook sell_asset bor_neigh remitt begging eat_else gath_wild)
label var cop_stra "Coping Strategy Index"

***4. Minimum Dietary Diversity - Women (MDD-W)***

*Grains, white roots and tubers, and plantains
gen mdd_grp_1 = 0
replace mdd_grp_1 = 1 if f_item_1 == 1 | f_item_2 == 1

*Pulses (beans, peas and lentils)
gen mdd_grp_2 = 0
replace mdd_grp_2 = 1 if f_item_3 == 1

*Nuts and seeds
gen mdd_grp_3 = 0
replace mdd_grp_3 = 1 if f_item_4 == 1

*Dairy
gen mdd_grp_4 = 0
replace mdd_grp_4 = 1 if f_item_5 == 1

*Meat, poultry and fish
gen mdd_grp_5 = 0
replace mdd_grp_5 = 1 if f_item_7 == 1 | f_item_9 == 1 | f_item_10 == 1 | f_item_11 == 1

*Eggs
gen mdd_grp_6 = 0
replace mdd_grp_6 = 1 if f_item_6 == 1

*Dark green leafy vegetables
gen mdd_grp_7 = 0
replace mdd_grp_7 = 1 if f_item_13 == 1

*other vitamin A-rich fruits and vegetables
gen mdd_grp_8 = 0
replace mdd_grp_8 = 1 if f_item_14 == 1 | f_item_15 == 1

*other vegetables
gen mdd_grp_9 = 0
replace mdd_grp_9 = 1 if f_item_17 == 1

*other fruits
gen mdd_grp_10 = 0
replace mdd_grp_10 = 1 if f_item_18 == 1

*raw MDD-W score
egen mdd_raw = rowtotal(mdd_grp_1 mdd_grp_2 mdd_grp_3 mdd_grp_4 mdd_grp_5 mdd_grp_6 mdd_grp_7 mdd_grp_8 mdd_grp_9 mdd_grp_10)

*binary score
gen mdd_bin = 0
replace mdd_bin = 1 if mdd_raw >= 5 & mdd_raw != .
label var mdd_bin "Minimum Dietary Diversity Indicator"


***5. Months of Adequate Household Food Provisioning***

unab months_16 : fs_months_m_16_*
egen mahfp_16 = rowtotal(`months_16')

unab months_07 : fs_months_m_07_*
egen mahfp_07 = rowtotal(`months_07')

gen mahfp_dif = mahfp_16 - mahfp_07

gen mon_food = mahfp_16
label var mon_food "Change in Months of Adequate Food Provision"

***6. Education Progression***

forvalues i = 1/18 {
gen child_`i'_14_17 = 1 if Oth_HH_Mem`i'_age_mem >= 14 & Oth_HH_Mem`i'_age_mem <= 17
}

forvalues i = 1/15 {
gen ch_`i'_edu_prog = 1 if Oth_HH_Mem`i'_educat_mem >= 8 & Oth_HH_Mem`i'_age_mem >= 14 & Oth_HH_Mem`i'_age_mem <= 17
}


unab ch_14_17 : child_*_14_17
egen ch_14_17_n = rsum(`ch_14_17')

unab ch_edu : ch_*_edu_prog
egen edu_prog_n = rsum(`ch_edu')

gen edu_prog = edu_prog_n/ch_14_17_n
label var edu_prog "Fraction of Secondary-Age Children in Secondary School"

***7. Education Spending***

gen edu_spe = educ_exp/num_child
label var edu_spe "Education Spending Per Child"

summarize edu_spe if edu_spe != 0, detail
replace edu_spe = `r(p75)' + (5 * (`r(p75)' - `r(p25)')) if edu_spe > `r(p75)' + (5 * (`r(p75)' - `r(p25)'))


***8. Perceived Changes on Economic Ladder***

gen eco_lad = step_16 - step_07
label var eco_lad "Change on Economic Ladder"

***Creation of Inverse Probability Weights

*try doing this yourself so that you can cluster standard errors:
probit prog_area $cov_sl_prog i.project, vce(robust)
predict pscore, p
gen w_ate = prog_area*(1/pscore) + (1-prog_area)*1/(1-pscore)



***Creation of Propensity Score***

set seed 123456
gen u = uniform()
sort u
psmatch2 prog_area $cov_sl_prog if project == 1, out(dif_pre_ce_pc) n(1) ties ate
pstest $covariates, t(prog_area)

gen pscore2 = _pscore + project*100 if _support == 1 & _weight!=. & project == 1

psmatch2 prog_area $cov_sl_prog if project == 2, out(dif_pre_ce_pc) cal(0.3) n(1) ties ate 
pstest $covariates, t(prog_area)

replace pscore2 = _pscore + project*100 if _support == 1 & _weight!=. & project == 2

psmatch2 prog_area $cov_sl_prog if project == 3, out(dif_pre_ce_pc) cal(0.4) n(1) ties ate 
pstest $covariates, t(prog_area)

replace pscore2 = _pscore + project*100 if _support == 1 & _weight!=. & project == 3

psmatch2 prog_area, pscore(pscore2) out(dif_pre_ce_pc) n(1) ties ate


*create reversal of treatment variables

recode prog_area (0=1) (1=0), g(prog_area_r)
recode vi_group (0=1) (1=0), g(vi_group_r)


*create binaries for "gainers" and "losers" in differenced outcome variables

gen dif_pre_ce_bin = 0
replace dif_pre_ce_bin = 1 if dif_pre_ce > 0

gen dif_asset_r_bin = 0
replace dif_asset_r_bin = 1 if dif_asset_r > 0




