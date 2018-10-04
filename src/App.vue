<script>
  import CandidatoItem from './components/CandidatoItem'
  import RadialProgressBar from 'vue-radial-progress'
  import axios from 'axios'
  import _orderBy from 'lodash/orderBy'

  function getApiEndpoint(cargo, abrangencia, uf) {
    const BASE_API = 'http://interessados.divulgacao.tse.jus.br/2018/divulgacao/oficial/'
    let codUf = (abrangencia === 'br') ? 'br' : uf
    let codEleicao = (abrangencia === 'br') ? 295 : 297
    const codCargo = {
      presidente: 1,
      governador: 3,
      senador: 5,
      dfederal: 6,
      destadual: 7,
      ddistrital: 8
    }

    return BASE_API + codEleicao + '/dadosdivweb/' + codUf + '/' + codUf + '-c000' + codCargo[cargo] + '-e000' + codEleicao + '-w.js'
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
        abrangencia: 'br',
        estado: null,
        completedSteps: 1,
        updateTime: 30
      }
    },
    mounted() {
      this.getGeralPresidente()
      setTimeout(() => this.completedSteps = 40, 1000)
      this.counter()
    },
    computed: {
      link() {
        return getApiEndpoint(this.cargo, this.abrangencia, this.estado)
      }
    },
    methods: {
      getGeralPresidente() {
        return axios.get(getApiEndpoint('presidente', 'br'))
          .then(res => this.geralPresidente = res.data)
      },
      orderBySeq(el) {
        return _orderBy(el, item => parseInt(item.seq))
      },
      counter() {
        setInterval(() => {
          if(this.updateTime === 0) {
            this.getGeralPresidente()
              .then(() => this.updateTime = 15)
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
            <h2>Presidente</h2>
            <p class="m-0 text-black-50">
              seções apuradas: <strong>50</strong> de 200
            </p>
          </div>
          <div class="ml-3">
            <radial-progress-bar :diameter="60"
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
      <CandidatoItem v-for="candidato in orderBySeq(geralPresidente.cand)" :key="candidato.sqcand" :candidato="candidato"></CandidatoItem>
    </div>
    <div class="col-md-4">
      <div class="section-head mb-5 pb-3">
        <h2>Opções</h2>
      </div>
    </div>
  </div>
</template>

<style scoped>
  * {
    font-family: 'Open Sans', sans-serif;
  }
  .section-head {
    border-bottom: 1px solid #ccc;
  }
  .progress, .progress-bar {
    height: 8px;
  }
</style>
