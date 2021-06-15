import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(
	JSON.parse(CampaignFactory.interface),
	'0x038Ee30A2116C7d7FB865b3146820A546e61aA71'
);

export default instance;