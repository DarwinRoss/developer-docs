//
//  SoapUtility.m
//  SOAP-IOS
//
//  Created by Elliott on 13-7-26.
//  Copyright (c) 2013 Elliott. All rights reserved.
//

#import "SoapUtility.h"


@interface SoapUtility(){
    DDXMLElement *rootelement;
}

@end

@implementation SoapUtility

-(id)initFromFile:(NSString *)filename{
    self=[super init];
    if(self){
        rootelement=[DDXMLElement LoadWSDL:filename];
    }
    return self;
}


-(NSString *)BuildSoapwithMethodName:(NSString *)methodName withParas:(NSDictionary *)parasdic
{
    // <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
	//     <soap:Header/>
	//     <soap:Body>
	//     <parameters xmlns="http://xxxx.com"/>
    //          <param1></param1>
    //          <param2></param2>
    //          <param3></param3>
	//     </parameters/>
	//     </soap:Body>
	// </soap:Envelope>
    
    DDXMLElement *ddRoot = [DDXMLElement elementWithName:@"soap:Envelope"];
    [ddRoot addNamespace:[DDXMLNode namespaceWithName:@"soap" stringValue:@"http://schemas.xmlsoap.org/soap/envelope/"]];
	DDXMLElement *ddHeader = [DDXMLElement elementWithName:@"soap:Header"];
    //body
    DDXMLElement *ddBody = [DDXMLElement elementWithName:@"soap:Body"];
    
    DDXMLNode *ddmsgNS = [DDXMLNode namespaceWithName:@"" stringValue:[rootelement TargetNamespace]];
    DDXMLElement *msg=[DDXMLElement elementWithName:[rootelement GetMessageParametersByMethodName:methodName]];
    [msg addNamespace:ddmsgNS];
    
    NSArray *params= [rootelement GetMethodParamsByMethodName:methodName];
    for(NSString *param in params){
        NSObject *paramValue=[parasdic objectForKey:param];
        if([paramValue isKindOfClass:[NSString class]]){
            DDXMLElement *paranode=[DDXMLElement elementWithName:param stringValue:(NSString *)paramValue];
            [msg addChild:paranode];
        }else if([paramValue isKindOfClass:[NSDictionary class]]){
            NSDictionary *tempDic=(NSDictionary *)paramValue;
            
            DDXMLElement *paranode1=[DDXMLElement elementWithName:param];
            
            for(NSString *param1 in tempDic){
                NSObject *tempparamValue=[tempDic objectForKey:param1];
                
                if([tempparamValue isKindOfClass:[NSDictionary class]]){
                    DDXMLElement *node=[DDXMLElement elementWithName:param1];
                    
                    NSDictionary *dic0=(NSDictionary *)tempparamValue;
                    for(NSString *p in dic0){
                        DDXMLElement *tnode=[DDXMLElement elementWithName:p stringValue:[dic0 objectForKey:p]];
                        [node addChild:tnode];
                    }
                    [paranode1 addChild:node];
                    
                }else{
                    DDXMLElement *tempNode=[DDXMLElement elementWithName:param1 stringValue:(NSString *)tempparamValue];
                    [paranode1 addChild:tempNode];
                }
                
                
            }
           
            [msg addChild:paranode1];
        }
        
    }
    [ddBody addChild:msg];
    [ddRoot addChild:ddHeader];
    [ddRoot addChild:ddBody];
    
    NSLog(@"request params = %@",msg);
    
    return [ddRoot XMLString];
}

-(NSString *)BuildSoap12withMethodName:(NSString *)methodName withParas:(NSDictionary *)parasdic
{
    // <soap12:Envelope xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
	//     <soap12:Header/>
	//     <soap12:Body>
	//     <parameters xmlns="http://xxxx.com"/>
    //          <param1></param1>
    //          <param2></param2>
    //          <param3></param3>
	//     </parameters/>
	//     </soap12:Body>
	// </soap12:Envelope>
    
    DDXMLElement *ddRoot = [DDXMLElement elementWithName:@"soap:Envelope"];
    [ddRoot addNamespace:[DDXMLNode namespaceWithName:@"soap" stringValue:@"http://www.w3.org/2003/05/soap-envelope"]];
	DDXMLElement *ddHeader = [DDXMLElement elementWithName:@"soap:Header"];
    //body
    DDXMLElement *ddBody = [DDXMLElement elementWithName:@"soap:Body"];
    
    DDXMLNode *ddmsgNS = [DDXMLNode namespaceWithName:@"" stringValue:[rootelement TargetNamespace]];
    DDXMLElement *msg=[DDXMLElement elementWithName:[rootelement GetMessageParametersByMethodName:methodName]];
    [msg addNamespace:ddmsgNS];
    
    NSArray *params= [rootelement GetMethodParamsByMethodName:methodName];
    
    for(NSString *param in params){
        NSString *paramValue=[parasdic objectForKey:param];
        DDXMLElement *paranode=[DDXMLElement elementWithName:param stringValue:paramValue];
        [msg addChild:paranode];
    }
    [ddBody addChild:msg];
    [ddRoot addChild:ddHeader];
    [ddRoot addChild:ddBody];
    return [ddRoot XMLString];
}



-(NSString *)GetSoapActionByMethodName:(NSString *)methodName SoapType:(SOAPTYPE)soapType{
    return [rootelement GetSoapActionByMethodName:methodName SoapType:soapType];
}
@end
