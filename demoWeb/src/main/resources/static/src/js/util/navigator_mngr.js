class NavigatorMngr {
	/*
	처음과는 다르게 처음엔 
	경로 path를 모두 가지려고 했다.
	아래처럼 그런데
	생각해보니까. pgm_mngr에서 div에 부모를 표시하면 되어서 굳이 안해도 될것 같다.
	*/
	// 이동경로를 다 체크 하는게 맞는것 같아보인다.
		// 마인드맵처럼 
		/*
		ROOT : {
			UUID : 'ROOT'
			PGM_ID  :  'ROOT'
			
			CHILD : [
				{
					UUID : '키'
					PGM_ID  :  '프로그램ID'
					CHILD : [ {} ]

				}


			]

		}
		  CHILD : [ 
				ㅕㅕㅑ{PGM_ID : 프로그램ID,  UUID: 키 } ]
		*/

	static navigatorHistory={};
	static appMap  = new Map();
    constructor(pgm_id, uuid) {
		
    }
	static add(PARENT_UUID,PGM_INFO){
		NavigatorMngr.addMap.add(PGM_INFO.getUuid,PGM_INFO.pgm_id);
		console.log('NavigatorMngr--add');
		console.log('PARENT_UUID');
		console.log(PARENT_UUID);
		console.log('PGM_ID');
		console.log(PGM_INFO.getPgmId());
		var tmp =NavigatorMngr.search(PARENT_UUID);
		console.log('parent');
		console.log(tmp);
		if(!tmp.CHILD){
			tmp.CHILD=[];
		}
		var len = tmp.CHILD.length;
		tmp.CHILD[len]={}
		tmp.CHILD[len]['UUID'] = PGM_INFO.getUuid();
		tmp.CHILD[len]['PGM_ID'] = PGM_INFO.getPgmId();
		tmp.CHILD[len]['PGM_INFO'] = PGM_INFO;
	}

	static remove(UUID) {
		console.log('NavigatorMngr--remove');
		console.log('UUID');
		console.log(UUID);
		var tmp =NavigatorMngr.search(UUID);
		UUID =null;
		//delete tmp;
	}

	static search(uuid){
		var tmp = NavigatorMngr.navigatorHistory;
		for (let key in tmp) { 
			if (tmp.hasOwnProperty(key)) { 
				console.log(tmp); 
				console.log(key); 
				console.log(tmp[key]); 
				if(key=='UUID' && tmp[key]==uuid) {
					console.log('ccc111122222222222222');
					return tmp;
				}
				if(key=='CHILD'){
					console.log('aaaaaaaaaaaaaaaaaa');
					for(var i=0;i<tmp[key].length;i++){
						var tmp2 = tmp[key][i];
						return NavigatorMngr.searchDeep(tmp2,uuid);
					}					
				}
			} 
		} 

	}
	static searchDeep(o,uuid){
		var tmp = o;
		for (let key in tmp) { 
			if (tmp.hasOwnProperty(key)) { 
				console.log("ddddddddddddddddd"); 
				console.log(tmp); 
				console.log(key); 
				console.log(tmp[key]); 
				if(key=='UUID' && tmp[key]==uuid) {
					console.log('ccc111111111111111111');
					console.log(tmp);
					return tmp;
				}
				if(key=='CHILD'){
					console.log('aaaaaaaaaaaaaaaaaa');
					for(var i=0;i<tmp[key].length;i++){
						var tmp2 = tmp[key][i];
						return NavigatorMngr.searchDeep(tmp2,uuid);
					}					
				}
			} 
		} 

	}
	static root(){
		NavigatorMngr.navigatorHistory={
			UUID : 'ROOT',
			PGM_ID  :  'ROOT',
			CHILD : []
		}
	}

	static testRoot(){
		var tmp = {
			UUID : 'ROOT',
			PGM_ID  :  'ROOT',
			CHILD : [
				{
					UUID : '1',
					PGM_ID  :  '프로그램ID',
					CHILD : [ {
						UUID : '2',
						PGM_ID  :  'PGM2',
						CHILD : []
					} ,
					{
						UUID : '3',
						PGM_ID  :  'PGM3',
						CHILD : []
					} 
				
				]
				}
			]
		}
		NavigatorMngr.navigatorHistory  =  tmp;
	}
	static test(){
		NavigatorMngr.testRoot();
		var tt = NavigatorMngr.search("2");
		console.log('ooooooooooooooo');
		console.log(tt);
		var num = tt.CHILD.length;

		tt.CHILD[num]={
			UUID : '4',
			PGM_ID  :  'PGM4',
			CHILD : []
		} ;
		console.log(NavigatorMngr.navigatorHistory);

	}
	static print(){
		console.log('NavigatorMngr-print');
		console.log(NavigatorMngr.navigatorHistory);
	}
}
NavigatorMngr.root();