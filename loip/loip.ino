#include <ip_arp_udp_tcp.h>
#include <net.h>
#include <etherShield.h>
#include <enc28j60.h>




// please modify the following two lines. mac and ip have to be unique
// in your local area network. You can not have the same numbers in
// two devices:
static uint8_t mymac[6] = {0x54,0x55,0x58,0x10,0x00,0x24}; 
static uint8_t myip[4] = {192,168,2,110};
static uint16_t my_port = 250; // A variavel eh um byte, entao ssomente portas abaixo de 256



#define BUFFER_SIZE 500
static uint8_t buf[BUFFER_SIZE+1];

EtherShield es=EtherShield();

#define LED_PIN 8


void setup(){  
  Serial.begin(9600);  
  Serial.println("");
  Serial.println("");
  Serial.println("=============================");
  Serial.println("..:: LED over IP ::..");
  
  Serial.println("== INICIANDO O SISTEMA ==");

  Serial.println(" => Inicia LED");
  pinMode(LED_PIN, OUTPUT); 
  digitalWrite(LED_PIN, LOW);
  Serial.println(" ===> LED iniciada");


  Serial.println(" => Inicia Ethernet");
   /*initialize enc28j60*/
	 es.ES_enc28j60Init(mymac);
   es.ES_enc28j60clkout(2); // change clkout from 6.25MHz to 12.5MHz
   delay(10);
        
	/* Magjack leds configuration, see enc28j60 datasheet, page 11 */
	// LEDA=greed LEDB=yellow
	//
	// 0x880 is PHLCON LEDB=on, LEDA=on
	// enc28j60PhyWrite(PHLCON,0b0000 1000 1000 00 00);
	es.ES_enc28j60PhyWrite(PHLCON,0x880);
	delay(500);
	//
	// 0x990 is PHLCON LEDB=off, LEDA=off
	// enc28j60PhyWrite(PHLCON,0b0000 1001 1001 00 00);
	es.ES_enc28j60PhyWrite(PHLCON,0x990);
	delay(500);
	//
	// 0x880 is PHLCON LEDB=on, LEDA=on
	// enc28j60PhyWrite(PHLCON,0b0000 1000 1000 00 00);
	es.ES_enc28j60PhyWrite(PHLCON,0x880);
	delay(500);
	//
	// 0x990 is PHLCON LEDB=off, LEDA=off
	// enc28j60PhyWrite(PHLCON,0b0000 1001 1001 00 00);
	es.ES_enc28j60PhyWrite(PHLCON,0x990);
	delay(500);
	//
  // 0x476 is PHLCON LEDA=links status, LEDB=receive/transmit
  // enc28j60PhyWrite(PHLCON,0b0000 0100 0111 01 10);
  es.ES_enc28j60PhyWrite(PHLCON,0x476);
	delay(100);
        
  //init the ethernet/ip layer:
  es.ES_init_ip_arp_udp_tcp(mymac,myip,my_port);
  
  Serial.println(" ===> Ethernet iniciada");
  
  Serial.println("== SISTEMA INICIADO ==");
  Serial.println("Aguardando pacotes...");
  Serial.println("");

}

void loop(){
  uint16_t plen, dat_p, dst_port;
  int8_t cmd;

  plen = es.ES_enc28j60PacketReceive(BUFFER_SIZE, buf);

	/*plen will ne unequal to zero if there is a valid packet (without crc error) */
  if(plen!=0){
	           
    // arp is broadcast if unknown but a host may also verify the mac address by sending it to a unicast address.
    if(es.ES_eth_type_is_arp_and_my_ip(buf,plen)){
      es.ES_make_arp_answer_from_request(buf);
      return;
    }

    // check if ip packets are for us:
    if(es.ES_eth_type_is_ip_and_my_ip(buf,plen)==0){
      return;
    }
    
    if(buf[IP_PROTO_P]==IP_PROTO_ICMP_V && buf[ICMP_TYPE_P]==ICMP_TYPE_ECHOREQUEST_V){
      Serial.println("=> Chegou um ping, respondendo com o um PONG :)");
      es.ES_make_echo_reply_from_request(buf,plen);
      return;
    }
    
    dst_port = buf[TCP_DST_PORT_H_P];
    dst_port <<= 0x08;
    dst_port |= buf[TCP_DST_PORT_L_P];
    
    
    if ((buf[IP_PROTO_P]==IP_PROTO_TCP_V) && (dst_port==my_port)){
      Serial.print("=> Chegou pacote TCP na porta [");
      Serial.print(dst_port, DEC);
      Serial.println("]");
      if (buf[TCP_FLAGS_P] & TCP_FLAGS_SYN_V){
        Serial.println("=> Responde com SYN/ACK");
        es.ES_make_tcp_synack_from_syn(buf); // make_tcp_synack_from_syn does already send the syn,ack
        return;     
      }
      if (buf[TCP_FLAGS_P] & TCP_FLAGS_ACK_V){
        es.ES_init_len_info(buf); // init some data structures
        dat_p=es.ES_get_tcp_data_pointer();
        if (dat_p==0){ // we can possibly have no data, just ack:
          if (buf[TCP_FLAGS_P] & TCP_FLAGS_FIN_V){
            es.ES_make_tcp_ack_from_any(buf);
          }
          return;
        }
        cmd = buf[dat_p+1];
        
        Serial.print("*** Comando recebido[");
        Serial.print(cmd, HEX);
        Serial.println("]");
        
        if(cmd == 0x00) {
          digitalWrite(LED_PIN, LOW);
        } else if(cmd == 0x01) {
          digitalWrite(LED_PIN, HIGH);
        } else {
          Serial.println("--- Comando invalido ---");
        }
    
SENDTCP:
        Serial.println("=> SENDTCP");
        //es.ES_make_tcp_ack_from_any(buf); // send ack for http get
        //es.ES_make_tcp_ack_with_data(buf,plen); // send data       
      }
    }
  }
        
}


