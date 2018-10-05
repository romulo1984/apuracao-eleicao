<script>
  import CandidatoItem from './components/CandidatoItem'
  import RadialProgressBar from 'vue-radial-progress'
  import axios from 'axios'
  import _orderBy from 'lodash/orderBy'

  window.SIMULATE_ENV = true
  window.MOCK = true

  function getApiEndpoint(cargo, abrangencia, uf) {
    let BASE_API = ''
    let codEleicao = ''

    if(SIMULATE_ENV) {
      BASE_API = 'http://interessados.divulgacao.tse.jus.br/2018/divulgacao/homologacaotre/'
      codEleicao = (abrangencia === 'br') ? '000295' : '007555'
    } else {
      BASE_API = 'http://interessados.divulgacao.tse.jus.br/2018/divulgacao/oficial/'
      codEleicao = (abrangencia === 'br') ? '000295' : '000297'
    }

    let codUf = (abrangencia === 'br') ? 'br' : uf

    const codCargo = {
      presidente: 1,
      governador: 3,
      senador: 5,
      dfederal: 6,
      destadual: 7,
      ddistrital: 8
    }

    if(MOCK)
      return 'http://127.0.0.1:3333/mock'

    return BASE_API + parseInt(codEleicao) + '/dadosdivweb/' + codUf + '/' + codUf + '-c000' + codCargo[cargo] + '-e' + codEleicao + '-w.js'
  }

  export default {
    name: 'App',
    components: {
      RadialProgressBar,
      CandidatoItem
    },
    data() {
      return {
        geralPresidente: {},
        cargo: 'presidente',
        abrangencia: 'uf',
        estado: null,
        updateTimeBase: 15,
        updateTime: 15,
      }
    },
    mounted() {
      this.getGeralPresidente()
      this.counter()
    },
    computed: {
      link() {
        return getApiEndpoint(this.cargo, this.abrangencia, this.estado)
      },
      completedSteps() {
        let completed = Math.floor((this.geralPresidente.st / this.geralPresidente.s) * 100)
        return isNaN(completed) ? 0 : completed
      }
    },
    methods: {
      getGeralPresidente() {
        return axios.get(getApiEndpoint('presidente', this.abrangencia, 'es'))
          .then(res => this.geralPresidente = res.data)
      },
      orderBySeq(el) {
        return _orderBy(el, item => parseInt(item.seq))
      },
      counter() {
        setInterval(() => {
          if(this.updateTime === 0) {
            this.getGeralPresidente()
              .then(() => this.updateTime = this.updateTimeBase)
              .catch(() => this.updateTime = this.updateTimeBase)
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
    <div class="col-md-12">
      <div class="section-head mb-2 pb-3">
        <div class="media">
          <div class="media-body">
            <h2>Presidente <div class="btn btn-sm btn-outline-secondary turn">{{ geralPresidente.t }}º turno</div></h2>
            <p class="m-0 text-black-50">
              seções apuradas: <strong>{{ geralPresidente.st }}</strong> de {{ geralPresidente.s }}
            </p>
          </div>
          <div class="ml-3">
            <radial-progress-bar
              :diameter="60"
              :completed-steps="completedSteps"
              :total-steps="100"
              :stroke-width="5"
              :inner-stroke-color="'#cccccc'"
              :start-color="'#007bff'"
              :stop-color="'#007bff'">
              <p class="m-0 p-0 text-black-50">{{ completedSteps }}%</p>
            </radial-progress-bar>
          </div>
        </div>
      </div>
      <div class="mb-4">
        <img src="./assets/bar-chart-preloader.svg" alt="Carregando..." width="25">
        <span class="text-black-50">atualizando em {{ updateTime }}</span>
      </div>
      <CandidatoItem v-for="candidato in orderBySeq(geralPresidente.cand)" :key="candidato.sqcand" :candidato="candidato" :geral="geralPresidente"></CandidatoItem>
    </div>
    <div class="col-md-4">
      <div class="section-head mb-5 pb-3">
        <h2>Opções</h2>
      </div>
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
  .progress, .progress-bar {
    height: 8px;
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
</style>
