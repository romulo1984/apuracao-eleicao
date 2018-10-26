<script>
  import CandidatoItem from './components/CandidatoItem'
  import ProgressCircle from './components/ProgressCircle'
  import axios from 'axios'
  import _orderBy from 'lodash/orderBy'

  window.SIMULATE_ENV = false
  window.MOCK = false
  //window.PROXY_TRIBUNA = 'https://tribunaonline.com.br/secureproxy/?'
  window.PROXY_TRIBUNA = 'http://'

  function getApiEndpoint(cargo, abrangencia, uf) {
    let BASE_API = ''
    let codEleicao = ''

    if(SIMULATE_ENV) {
      BASE_API = PROXY_TRIBUNA + 'interessados.divulgacao.tse.jus.br/2018/divulgacao/homologacaotre/'
      codEleicao = (abrangencia === 'br') ? '000295' : '007555'
    } else {
      BASE_API = PROXY_TRIBUNA + 'interessados.divulgacao.tse.jus.br/2018/divulgacao/oficial/'
      codEleicao = (abrangencia === 'br') ? '000295' : '000297'
    }

    let codUf = (abrangencia === 'br') ? 'br' : uf

    const codCargo = cargo

    if(MOCK)
      return 'http://127.0.0.1:8989/mock'

    return BASE_API + parseInt(codEleicao) + '/dadosdivweb/' + codUf + '/' + codUf + '-c000' + codCargo + '-e' + codEleicao + '-w.js'
  }

  const updateTimeBase = 15

  export default {
    name: 'Regional',
    components: {
      CandidatoItem,
      ProgressCircle
    },
    data() {
      return {
        geral: {},
        cargo: 3,
        abrangencia: 'uf',
        estado: 'es',
        updateTime: 15,
        loading: true,
        searchCandidate: '',
        cargosPossiveis: {
          3: 'Governador',
          5: 'Senador',
          6: 'Deputado Federal',
          7: 'Deputado Estadual',
          8: 'Deputado Distrital'
        },
        estadosPossiveis: {
          ac: 'Acre',
          al: 'Alagoas',
          ap: 'Amapá',
          am: 'Amazonas',
          ba: 'Bahia',
          ce: 'Ceará',
          df: 'Distrito Federal',
          es: 'Espírito Santo',
          go: 'Goiás',
          ma: 'Maranhão',
          mt: 'Mato Grosso',
          ms: 'Mato Grosso do Sul',
          mg: 'Minas Gerais',
          pa: 'Pará',
          pb: 'Paraíba',
          pr: 'Paraná',
          pe: 'Pernambuco',
          pi: 'Piauí',
          rj: 'Rio de Janeiro',
          rn: 'Rio Grande do Norte',
          rs: 'Rio Grande do Sul',
          ro: 'Rondônia',
          rr: 'Roraima',
          sc: 'Santa Catarina',
          sp: 'São Paulo',
          se: 'Sergipe',
          to: 'Tocantins'
        }
      }
    },
    mounted() {
      this.getGeralPresidente()
      this.counter()
    },
    watch: {
      cargo() {
        if(this.cargo == 8) {
          this.estado = 'df'
        }

        this.getGeralPresidente()
      },
      estado() {
        if(this.estado != 'df' && this.cargo == 8) {
          this.cargo = 7
        }
        this.getGeralPresidente()
      }
    },
    computed: {
      link() {
        return getApiEndpoint(this.cargo, this.abrangencia, this.estado)
      },
      completedSteps() {
        let completed = Math.floor((this.geral.st / this.geral.s) * 100)
        return isNaN(completed) ? 0 : completed
      }
    },
    methods: {
      getGeralPresidente() {
        this.loading = true
        return axios.get(getApiEndpoint(this.cargo, this.abrangencia, this.estado))
          .then(res => {
            this.loading = false
            return this.geral = res.data
          })
          .catch(() => {
            this.loading = false
          })
      },
      orderBySeq(el) {
        if(el) {
          const newEl = el.filter((item) => {
            const calc = item.v > (parseInt(this.geral.vv) + parseInt(this.geral.ena))/2
            const newItem = {...item, matematicamenteEleito: calc}
            if(this.searchCandidate === '' || newItem.nm.toLowerCase().indexOf(this.searchCandidate.toLowerCase()) > -1) {
              return newItem
            }
          })

          return _orderBy(newEl, item => parseInt(item.seq))
        }
      },
      counter() {
        setInterval(() => {
          if(this.updateTime === 0) {
            this.getGeralPresidente()
              .then(() => this.updateTime = updateTimeBase)
              .catch(() => this.updateTime = updateTimeBase)
          } else {
            this.updateTime--
          }
        }, 1000)
      }
    }
  }
</script>

<template>
  <div class="row mt-5">
    <div class="col-12 mb-3">
      <div class="row">
        <div class="col-md-5">
          <div class="form-group">
            <select class="form-control" v-model="cargo">
              <option v-for="(item, key) in cargosPossiveis" :key="key" :value="key">{{ item }}</option>
            </select>
          </div>
        </div>
        <div class="col-md-7">
          <div class="form-group">
            <select class="form-control" v-model="estado">
              <option v-for="(item, key) in estadosPossiveis" :key="key" :value="key">{{ item }}</option>
            </select>
          </div>
        </div>
      </div>
    </div>
    <div class="col-md-12">
      <div class="section-head mb-2 pb-3">
        <div class="media">
          <div class="media-body">
            <h2>{{ cargosPossiveis[cargo] }} <div v-if="cargo === 3" class="btn btn-sm btn-outline-secondary turn">{{ geral.t }}º turno</div></h2>
            <p class="m-0 text-black-50">
              seções apuradas: <strong>{{ geral.st }}</strong> de {{ geral.s }}
            </p>
          </div>
          <div class="ml-3">
            <ProgressCircle :percent="completedSteps" :color="'#007bff'" :inner="'#cccccc'"/>
          </div>
        </div>
      </div>
      <div class="mb-3">
        <img src="https://s3.amazonaws.com/static.tribunaonline.com.br/general-assets-apps/apuracao/regional/bar-chart-preloader.176c94fd.svg" alt="Carregando..." width="25">
        <span class="text-black-50">atualizando em {{ updateTime }}</span>
        <div v-if="loading" class="d-inline-block ml-md-3">
          <img src="https://s3.amazonaws.com/static.tribunaonline.com.br/general-assets-apps/apuracao/regional/double-rings.5cf5e57c.svg" alt="Carregando..." width="25">
          <span class="text-black-50">
            carregando...
          </span>
        </div>
      </div>
      <div class="form-group mb-4">
        <input type="text" v-model="searchCandidate" placeholder="Busque pelo nome do candidato..." class="form-control">
      </div>
      <candidato-item v-for="candidato in orderBySeq(geral.cand)" :key="candidato.sqcand" :candidato="candidato" :geral="geral"></candidato-item>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  * {
    font-family: 'Open Sans', sans-serif;
  }
  .section-head {
    border-bottom: 1px solid #ccc;
  }
  
  .turn {
    &:hover,
    &:active,
    &:focus,
    &:visited {
      cursor: default !important;
      background-color: inherit !important;
      color: inherit !important;
    }
  }

  pprogress {
    vertical-align: baseline;
  }

  .pprogress {
    display: -ms-flexbox;
    display: flex;
    height: 1rem;
    overflow: hidden;
    font-size: .75rem;
    background-color: #e9ecef;
    border-radius: .25rem;
  }

  .pprogress-bar {
    display: -ms-flexbox;
    display: flex;
    -ms-flex-direction: column;
    flex-direction: column;
    -ms-flex-pack: center;
    justify-content: center;
    color: #fff;
    text-align: center;
    white-space: nowrap;
    background-color: #007bff;
    transition: width 0.6s ease;
  }

  @media screen and (prefers-reduced-motion: reduce) {
    .pprogress-bar {
      transition: none;
    }
  }
  .pprogress-bar-animated {
    -webkit-animation: pprogress-bar-stripes 1s linear infinite;
    animation: pprogress-bar-stripes 1s linear infinite;
  }

  @-webkit-keyframes pprogress-bar-stripes {
    from {
      background-position: 1rem 0;
    }
    to {
      background-position: 0 0;
    }
  }

  @keyframes pprogress-bar-stripes {
    from {
      background-position: 1rem 0;
    }
    to {
      background-position: 0 0;
    }
  }

  .pprogress-bar-striped {
    background-image: linear-gradient(45deg, rgba(255, 255, 255, 0.15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, 0.15) 50%, rgba(255, 255, 255, 0.15) 75%, transparent 75%, transparent);
    background-size: 1rem 1rem;
  }

  .pprogress, .pprogress-bar {
    height: 8px;
  }
</style>
