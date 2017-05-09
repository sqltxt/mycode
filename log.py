#! /usr/bin/env python'''

#-*-coding:utf-8-*-
import queue
import requests
import json
import datetime
import time
import os
import csv

day = {0:0}
ctporder=[0,0,0,0,0]
sorder=[0,0,0,0,0]
AutoTrade=[0,0,0,0,0]
userop=[0,0,0,0,0]
mylog = [0,0,0,0,0]
Account1=[0,0,0,0,0]
Account2=[0,0,0,0,0]
Account3=[0,0,0,0,0]
Account4=[0,0,0,0,0]
Account5=[0,0,0,0,0]
Account6=[0,0,0,0,0]
def newday():
    week_day = {
        0: '周一',
        1: '周二',
        2: '周三',
        3: '周四',
        4: '周五',
        5: '周六',
        6: '周日',
    }
    AutoTrade[0]    =   'C:/Users/Administrator/Documents/tbv5321_x64_portable/AutoTrade/'+time.strftime('%Y%m%d')+".log"
    ctporder[0]     =   'C:/Users/Administrator/Documents/tbv5321_x64_portable/ctporder/'+time.strftime('%Y%m%d')+'_z34,8899_'+"81103959"+".txt"
    sorder[0]       =   'C:/Users/Administrator/Documents/tbv5321_x64_portable/sorder/'+time.strftime('%Y%m%d')+'_'+"81103959"+".txt"
    mylog[0]        =   'C:/Users/Administrator/Documents/tbv5321_x64_portable/'+'LOG_'+time.strftime('%Y%m%d')+'_'+week_day[datetime.datetime.now().weekday()]+'.txt'
    mylog[2]        =   'utf-8'
    
    userop[0]       =   'C:/Users/Administrator/Documents/tbv5321_x64_portable/userop/'+time.strftime('%Y%m%d')+'.txt'
    Account1[0]     =   'C:/Users/Administrator/Documents/tbv5321_x64_portable/Account/'+time.strftime('%Y-%m-%d')+" 0233"+"_持仓统计.csv"
    Account2[0]     =   'C:/Users/Administrator/Documents/tbv5321_x64_portable/Account/'+time.strftime('%Y-%m-%d')+" 0233"+"_帐户汇总.csv"
    Account3[0]     =   'C:/Users/Administrator/Documents/tbv5321_x64_portable/Account/'+time.strftime('%Y-%m-%d')+" 0233"+"_当日交易.csv"
    Account4[0]     =   'C:/Users/Administrator/Documents/tbv5321_x64_portable/Account/'+time.strftime('%Y-%m-%d')+" 1530"+"_持仓统计.csv"
    Account5[0]     =   'C:/Users/Administrator/Documents/tbv5321_x64_portable/Account/'+time.strftime('%Y-%m-%d')+" 1530"+"_帐户汇总.csv"
    Account6[0]     =   'C:/Users/Administrator/Documents/tbv5321_x64_portable/Account/'+time.strftime('%Y-%m-%d')+" 1530"+"_当日交易.csv"

    ctporder[3]     =   'ctporder'
    sorder[3]       =   'sorder'
    AutoTrade[3]    =   'AutoTrade'
    userop[3]       =   'userop'
    mylog[3]        =   'mylog'
    Account1[3]     =   'Account1'
    Account2[3]     =   'Account2'
    Account3[3]     =   'Account3'
    Account4[3]     =   'Account4'
    Account5[3]     =   'Account5'
    Account6[3]     =   'Account6'

    ctporder[4]     =   'CTP发单记录'
    sorder[4]       =   '柜台记录'
    AutoTrade[4]    =   '图表交易信号'
    userop[4]       =   '用户操作记录'
    mylog[4]        =   '开拓者日志'
    Account1[4]     =   '持仓统计_夜盘'
    Account2[4]     =   '帐户汇总_夜盘'
    Account3[4]     =   '当日交易_夜盘'
    Account4[4]     =   '持仓统计_日盘'
    Account5[4]     =   '帐户汇总_日盘'
    Account6[4]     =   '当日交易_日盘'

    #print(Account1[0])

    if day[0] != time.strftime('%Y%m%d'):
        ctporder[1] =   0
        sorder[1]   =   0
        AutoTrade[1]=   0
        userop[1]   =   0
        mylog[1]    =   0
        Account1[1] =   0
        Account2[1] =   0
        Account3[1] =   0
        Account4[1] =   0
        Account5[1] =   0
        Account6[1] =   0
        
        day[0] = time.strftime('%Y%m%d')
        print ("新的一天开始了")
        send_msg("New day New begining!")
        
def get_token():
    url='https://qyapi.weixin.qq.com/cgi-bin/gettoken'
    values = {'corpid' :'wx87780fb826353ecc',# 'wx87780fb826353ecc' ,#
              'corpsecret':'jrZvrrQ1Q_zICTbZas651lO7p0jhxLdo3kQ0Pz2fAI_9O_H7YDGUB6qmrqE9dX0y'#'jrZvrrQ1Q_zICTbZas651lO7p0jhxLdo3kQ0Pz2fAI_9O_H7YDGUB6qmrqE9dX0y',#04d468d79d4ade68f49c58d4a5bd481f
              }
    req = requests.post(url, params=values)
    j = json.loads(req.text)
    print (j)
    print(j["access_token"])
    return j["access_token"]
    
def send_msg(msg):
            #print(msg)
            if msg != None:
                        url="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token="+get_token()
                        dict_arr        = {"touser":"@all",
                                           "toparty":"@all",
                                           "msgtype":"text",
                                           "agentid":"3",
                                           "text":{"content":msg},
                                           "safe":"0"}
                        data   = json.dumps(dict_arr,ensure_ascii=False,indent=2,sort_keys=True).encode('utf-8')
                        req = requests.post(url,data)
                        #读取json数据
                        j = json.loads(req.text)
                        j.keys()
                        print (datetime.datetime.now().strftime('%Y-%m-%d %H-%M-%S'))
                        print(j)
                        
def get_txt(l):
    if os.path.exists(l[0]):
        if l[2]=='utf-8':
            f = open(l[0],'r',encoding='utf-8')#utf-8
        else:
            f = open(l[0],'r',encoding='gbk')#utf-8                                        
        if os.path.getsize(l[0]) > l[1]:
            f.seek(l[1],0)
            d=f.readline()
            #l[1]=os.path.getsize(l[0])
            l[1]=f.tell()
            f.close
            #return d
            if l[3]=='sorder':
                #s=d.split()
                y=d.replace(']',']\n')
            elif l[3]=='userop':
                #s=d.splitlines()
                y=d.replace(' ','\n')
            elif l[3]=='ctporder':
                y=d.replace(' ','\n')
            elif l[3]=='AutoTrade':
                y=d.replace(']',']\n')
            elif l[3]=='mylog':
                y=d
            else:
                y=d
            #print (y)
            return l[4]+':\n'+y
def get_csv(l):    
    if os.path.exists(l[0]):
        if os.path.getsize(l[0]) > l[1]:
            l[1]=os.path.getsize(l[0])
            y=''
            with open(l[0],'r') as csvfile:
               reader = csv.reader(csvfile)
               for row in reader:
                if l[3]=='Account1':                    
                    y=y+row[0]+'\t'+row[1]+'\t'+row[2]+'\n'
                elif l[3]=='Account2':                    
                    y=y+row[0]+'\t'+row[4]+'\n'
                elif l[3]=='Account3':
                    y=y+row[0]+'\t'+row[2]+'\t'+row[3]+'\t'+row[5]+'\t'+row[6]+'\t'+row[7]+'\n'
                elif l[3]=='Account4':
                    y=y+row[0]+'\t'+row[1]+'\t'+row[2]+'\n'
                elif l[3]=='Account5':                    
                    y=y+row[0]+'\t'+row[4]+'\n'
                elif l[3]=='Account6':                    
                    y=y+row[0]+'\t'+row[2]+'\t'+row[3]+'\t'+row[5]+'\t'+row[6]+'\t'+row[7]+'\n'
                else:
                     y=r                
            return  l[4]+':\n'+y

def get_pic():
    from PIL import ImageGrab
    im=ImageGrab.grab()
    pic='C:/Users/Administrator/Documents/tbv5321_x64_portable/'+time.strftime('%Y-%m-%d %H-%M-%S')+".jpg"
    im.save(pic)
    
    img_url='https://api.weixin.qq.com/cgi-bin/material/add_material'
    payload={
        'access_token':get_token(),
        'type':'image'
        }
    print(payload)
    data={'media':open(pic,'rb')}
    print(data)
    r=requests.post(url=img_url,params=payload,files=data)
    print(r)
    if r.status_code==200:
        dicts =r.json()
        print (dicts)
        return dicts['media_id']
    
def send_pic():

                        url="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token="+get_token()
                        data        = {"touser":"@all",
                                           "toparty":"@all",
                                           "msgtype":"image",
                                           "agentid":"3",
                                           "image":{"media_id":media_id},
                                           "safe":"0"}
                        #data   = json.dumps(dict_arr,ensure_ascii=False,indent=2,sort_keys=True).encode('utf-8')
                        req = requests.post(url,data=json.dumps(data))
                        #读取json数据
                        j = json.loads(req.text)
                        j.keys()
                        print (datetime.datetime.now().strftime('%Y-%m-%d %H-%M-%S'))
                        print(j)

    
if __name__ == '__main__':
            while True:
                
                newday()
                send_msg(get_txt(AutoTrade))
                send_msg(get_txt(ctporder))
                send_msg(get_txt(sorder))
                #send_msg(get_txt(userop))
                send_msg(get_txt(mylog))
                send_msg(get_csv(Account1))
                send_msg(get_csv(Account2))
                send_msg(get_csv(Account3))
                send_msg(get_csv(Account4))
                send_msg(get_csv(Account5))
                send_msg(get_csv(Account6))
                
                #send_pic(get_pic())
                time.sleep(15)

