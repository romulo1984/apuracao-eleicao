<script>
import CandidatoItem from './components/CandidatoItem'
import ProgressCircle from './components/ProgressCircle'
import axios from 'axios'
import _orderBy from 'lodash/orderBy'

window.PROXY_TRIBUNA = 'https://tribunaonline.com.br/secureproxy/?'
// window.PROXY_TRIBUNA = 'http://'

function getApiEndpoint (cargo, abrangencia, uf, turno) {
  const BASE_API = PROXY_TRIBUNA + 'interessados.divulgacao.tse.jus.br/2018/divulgacao/oficial/'
  const codEleicao = (turno == 1) ? '000297' : '000298'

  const codUf = uf
  const codCargo = cargo

  return BASE_API + parseInt(codEleicao) + '/dadosdivweb/' + codUf + '/' + codUf + '-c000' + codCargo + '-e' + codEleicao + '-w.js'
}

export default {
  name: 'Regional',
  components: {
    CandidatoItem,
    ProgressCircle
  },
  data () {
    return {
      geral: {},
      cargo: 3,
      abrangencia: 'uf',
      estado: 'sp',
      turno: 2,
      updateTime: 15,
      updateTimeBase: 15,
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
        ac: { name: 'Acre', segundoTurno: false },
        al: { name: 'Alagoas', segundoTurno: false },
        ap: { name: 'Amapá', segundoTurno: true },
        am: { name: 'Amazonas', segundoTurno: true },
        ba: { name: 'Bahia', segundoTurno: false },
        ce: { name: 'Ceará', segundoTurno: false },
        df: { name: 'Distrito Federal', segundoTurno: true },
        es: { name: 'Espírito Santo', segundoTurno: false },
        go: { name: 'Goiás', segundoTurno: false },
        ma: { name: 'Maranhão', segundoTurno: false },
        mt: { name: 'Mato Grosso', segundoTurno: false },
        ms: { name: 'Mato Grosso do Sul', segundoTurno: true },
        mg: { name: 'Minas Gerais', segundoTurno: true },
        pa: { name: 'Pará', segundoTurno: true },
        pb: { name: 'Paraíba', segundoTurno: false },
        pr: { name: 'Paraná', segundoTurno: false },
        pe: { name: 'Pernambuco', segundoTurno: false },
        pi: { name: 'Piauí', segundoTurno: false },
        rj: { name: 'Rio de Janeiro', segundoTurno: true },
        rn: { name: 'Rio Grande do Norte', segundoTurno: true },
        rs: { name: 'Rio Grande do Sul', segundoTurno: true },
        ro: { name: 'Rondônia', segundoTurno: true },
        rr: { name: 'Roraima', segundoTurno: true },
        sc: { name: 'Santa Catarina', segundoTurno: true },
        sp: { name: 'São Paulo', segundoTurno: true },
        se: { name: 'Sergipe', segundoTurno: true },
        to: { name: 'Tocantins', segundoTurno: false }
      }
    }
  },
  mounted () {
    this.getGeralPresidente()
    this.counter()
  },
  watch: {
    cargo () {
      if (this.cargo == 8) {
        this.estado = 'df'
      }

      this.getGeralPresidente()
    },
    estado () {
      if (this.estado != 'df' && this.cargo == 8) {
        this.cargo = 7
      }
      this.getGeralPresidente()
    }
  },
  computed: {
    completedSteps () {
      let completed = Math.floor((this.geral.st / this.geral.s) * 100)
      return isNaN(completed) ? 0 : completed
    },
    candidatosOrderedBySeq () {
      if (this.geral.cand) {
        const newElFilter = this.geral.cand.filter((item) => {
          if (this.searchCandidate == '' || item.nm.toLowerCase().indexOf(this.searchCandidate.toLowerCase()) > -1) {
            return item
          }
        })

        const newEl = newElFilter.map((item) => {
          const calc = item.v > (parseInt(this.geral.vv) + parseInt(this.geral.ena)) / 2
          const newItem = { ...item, matematicamenteEleito: calc }
          return newItem
        })

        return _orderBy(newEl, item => {
          return parseInt(item.seq)
        })
      }
    }
  },
  methods: {
    changeTurno (turno) {
      this.turno = turno
      this.getGeralPresidente()
    },
    getGeralPresidente () {
      this.loading = true
      this.turno = (this.estadosPossiveis[this.estado].segundoTurno && this.cargo == 3) ? this.turno : 1
      return axios.get(getApiEndpoint(this.cargo, this.abrangencia, this.estado, this.turno))
        .then(res => {
          this.loading = false
          return this.geral = res.data
        })
        .catch(() => {
          this.loading = false
        })
    },
    counter () {
      setInterval(() => {
        if (this.turno === 2) {
          if (this.updateTime === 0) {
            this.getGeralPresidente()
              .then(() => this.updateTime = this.updateTimeBase)
              .catch(() => this.updateTime = this.updateTimeBase)
          } else {
            this.updateTime--
          }
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
              <option v-for="(item, key) in estadosPossiveis" :key="key" :value="key">
                {{ item.name }}<span v-if="item.segundoTurno && cargo == 3">: 2º turno</span>
              </option>
            </select>
          </div>
        </div>
      </div>
    </div>
    <div class="col-md-12">
      <div class="section-head mb-2 pb-3">
        <div class="media">
          <div class="media-body">
            <h2>
              {{ cargosPossiveis[cargo] }}
              <div v-if="cargo == 3" class="d-inline-block">
                <div v-if="estadosPossiveis[estado].segundoTurno" class="btn btn-sm btn-outline-secondary turn" @click="changeTurno(2)" :class="{'selected': turno == 2}">2º turno</div>
                <div class="btn btn-sm btn-outline-secondary turn" @click="changeTurno(1)" :class="{'selected': turno == 1}">1º turno</div>
              </div>
            </h2>
            <p class="m-0 text-black-50">
              seções apuradas: <strong>{{ geral.st }}</strong> de {{ geral.s }}
            </p>
          </div>
          <div class="ml-3">
            <ProgressCircle :percent="completedSteps" :color="'#007bff'" :inner="'#cccccc'" />
          </div>
        </div>
      </div>
      <div class="mb-4" v-if="turno == 2">
        <img src="https://s3.amazonaws.com/static.tribunaonline.com.br/general-assets-apps/apuracao/presidente/bar-chart-preloader.176c94fd.svg" alt="Carregando..." width="25">
        <span class="text-black-50">atualizando em {{ updateTime }}</span>
        <div v-if="loading" class="d-inline-block ml-md-3">
          <img src="https://s3.amazonaws.com/static.tribunaonline.com.br/general-assets-apps/apuracao/regional/double-rings.5cf5e57c.svg" alt="Carregando..." width="25">
          <span class="text-black-50">
            carregando...
          </span>
        </div>
      </div>
      <div class="mb-4" v-else>
        <span class="text-black-50">apuração encerrada</span>
      </div>
      <div class="form-group mb-4">
        <input type="text" v-model="searchCandidate" placeholder="Busque pelo nome do candidato..." class="form-control">
      </div>
      <candidato-item v-for="candidato in candidatosOrderedBySeq" :key="candidato.sqcand" :candidato="candidato" :geral="geral" :turno="turno"></candidato-item>
    </div>
  </div>
</template>

<style lang="scss" scoped>
* {
  font-family: "Open Sans", sans-serif;
}
.section-head {
  border-bottom: 1px solid #ccc;
}

.turn {
  opacity: 0.4;
  &.selected {
    opacity: 1;
  }
  &:hover {
    color: #000 !important;
    background-color: #fff;
    opacity: 0.6;
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
  font-size: 0.75rem;
  background-color: #e9ecef;
  border-radius: 0.25rem;
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
  background-image: linear-gradient(
    45deg,
    rgba(255, 255, 255, 0.15) 25%,
    transparent 25%,
    transparent 50%,
    rgba(255, 255, 255, 0.15) 50%,
    rgba(255, 255, 255, 0.15) 75%,
    transparent 75%,
    transparent
  );
  background-size: 1rem 1rem;
}

.pprogress,
.pprogress-bar {
  height: 8px;
}
</style>
