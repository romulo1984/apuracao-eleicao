const BASE_BRASIL = 'http://interessados.divulgacao.tse.jus.br/2018/divulgacao/oficial/297/dadosdivweb/es/es-c0003-e000297-w.js';

function getApiEndpoint(cargo, abrangencia, uf) {
    const BASE_API = 'http://interessados.divulgacao.tse.jus.br/2018/divulgacao/oficial/';
    let codUf = (abrangencia === 'br') ? 'br' : uf;
    let codEleicao = (abrangencia === 'br') ? 295 : 297;
    const codCargo = {
        presidente: 1,
        governador: 3,
        senador: 5,
        dfederal: 6,
        destadual: 7,
        ddistrital: 8
    };

    return BASE_API + codEleicao + '/dadosdivweb/' + codUf + '/' + codUf + '-c000' + codCargo[cargo] + '-e000' + codEleicao + '-w.js';
}

const indexApp = new Vue({
    el: '#index-app',
    delimiters: ['${', '}'],
    data: {
        cargo: 'presidente',
        abrangencia: 'br',
        estado: null
    },
    computed: {
        link() {
            return getApiEndpoint(this.cargo, this.abrangencia, this.estado);
        }
    }
})