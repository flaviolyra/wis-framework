# -*- coding: utf-8 -*-
"""
/***************************************************************************
 FerramentaMontanteJusanteTabela
                                 
 ao clicar trecho de hidrografia, identifica o trecho e o rio e abre dialogo
 que permite especificar o que se quer mostrar a montante ou a jusante
 (criação de layers e relatorios) - versão com criação de tabela na base de dados
                              -------------------
        begin                : 2015-12-22
        git sha              : $Format:%H$
        copyright            : (C) 2015 by Flavio Lyra
        email                : flavio.jose.lyra@gmail.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""

from qgis.gui import QgsMapToolEmitPoint
from qgis.core import QgsRectangle, QgsDataSourceURI, QgsVectorLayer, QgsMapLayerRegistry, QgsFillSymbolV2
from PyQt4.QtGui import QMessageBox, QTreeWidgetItem
from montante_jusante_tabela_dialog import MontanteJusanteTabelaDialog
import psycopg2

class ErroAcessoBaseDados(Exception):
    pass

class ErroCamada(Exception):
    pass

class ExcecaoNadaSelecionado(Exception):
    pass

class ErroMapaInvalido(Exception):
    pass

class FerramentaMontanteJusanteTabela(QgsMapToolEmitPoint):

    def __init__(self, canvas):
        self.canvas = canvas
        QgsMapToolEmitPoint.__init__(self, canvas)

        
    def canvasPressEvent(self, e):
        try:
            self.camada=self.canvas.currentLayer()
            if not self.camada or self.camada.id()[:-17] <> 'hidrografia':
                raise ErroCamada()
            # seleciona na camada por um quadrado de 4 x 4 pixels em torno do ponto clicado
            ptinfesq = self.canvas.getCoordinateTransform().toMapCoordinates(e.pos().x()-2, e.pos().y()+2)
            ptsupdir = self.canvas.getCoordinateTransform().toMapCoordinates(e.pos().x()+2, e.pos().y()-2)
            self.camada.setSelectedFeatures([])
            self.camada.select(QgsRectangle(ptinfesq, ptsupdir), True)
            #busca nome do rio, cobacia, area montante, codigo do rio e comprimento à foz dos trechos selecionados
            lst_atr_sel=[]
            for trecho in self.camada.selectedFeatures():
                lst_atr_sel.append([trecho['noriocomp'], trecho['cobacia'], trecho['nuareamont'], trecho['corio'], trecho['nudistbact'], trecho['nudistbacr'], trecho['cotrecho']])
            if not lst_atr_sel:
                raise ExcecaoNadaSelecionado()
            # pega o trecho com maior area a montante
            trecho = sorted(lst_atr_sel, key = lambda tr: tr[2])[-1]
            # anota em cobacia o codigo pfafstetter do trecho
            cobacia = trecho[1]
            id_trecho = trecho[6]
            dist_tr = trecho[4]
            dist_fozrio = trecho[5]
            # desabilita a ferramenta
            self.canvas.unsetMapTool(self.canvas.mapTool())
            # Cria o dialogo e guarda referencia
            self.dlg = MontanteJusanteTabelaDialog()
            # escreve no dialogo o nome do rio, quilometragem e area a montante
            if trecho[0] <> None:
                self.dlg.label.setText("{0} - km {1:.2f}".format(trecho[0].encode(encoding='cp1252'), dist_tr - dist_fozrio))
                self.dlg.label_2.setText("Codigo: {0}".format(trecho[3]))
            self.dlg.label_3.setText("Area a Montante: {0:.2f} km2".format(trecho[2]))
            self.dlg.treeWidget.setHeaderLabels(['Caracteristica', 'Topologia', 'Forma'])
            itensTabela = []
            self.var_cens_mont = QTreeWidgetItem(['Variaveis Censitarias', 'Montante', 'Tabela'], 0)
            itensTabela.append(self.var_cens_mont)
            self.uso_solo_mont = QTreeWidgetItem(['Uso do Solo', 'Montante', 'Tabela'], 0)
            itensTabela.append(self.uso_solo_mont)
            self.usina_mont = QTreeWidgetItem(['Usinas', 'Montante', 'Mapa'], 0)
            itensTabela.append(self.usina_mont)
            self.usina_jus = QTreeWidgetItem(['Usinas', 'Jusante', 'Mapa'], 0)
            itensTabela.append(self.usina_jus) 
            self.barr_mont = QTreeWidgetItem(['Barragens', 'Montante', 'Mapa'], 0)
            itensTabela.append(self.barr_mont) 
            self.barr_jus = QTreeWidgetItem(['Barragens', 'Jusante', 'Mapa'], 0)
            itensTabela.append(self.barr_jus)
            self.posto_flu_mont = QTreeWidgetItem(['Postos Fluviometricos', 'Montante', 'Mapa'], 0)
            itensTabela.append(self.posto_flu_mont)
            self.posto_flu_jus = QTreeWidgetItem(['Postos Fluviometricos', 'Jusante', 'Mapa'], 0)
            itensTabela.append(self.posto_flu_jus) 
            self.bac_mont = QTreeWidgetItem(['Bacia', 'Montante', 'Mapa'], 0)
            itensTabela.append(self.bac_mont) 
            self.trechos_mont = QTreeWidgetItem(['Trechos', 'Montante', 'Mapa'], 0)
            itensTabela.append(self.trechos_mont)
            self.curso_princ_jus = QTreeWidgetItem(['Curso Principal', 'Jusante', 'Mapa'], 0)
            itensTabela.append(self.curso_princ_jus) 
            self.curso_tot_jus = QTreeWidgetItem(['Curso Total', 'Jusante', 'Mapa'], 0)
            itensTabela.append(self.curso_tot_jus) 
            self.dlg.treeWidget.insertTopLevelItems(0, itensTabela)
            # exibe o dialogo
            self.dlg.show()
            # Entra no loop do dialogo
            result = self.dlg.exec_()
            # Ve se OK foi pressionado
            if result:
                # põe na uri self.uri_ex os dados da conexao da camada hidrografia na base PostGIS
                self.uri_ex = QgsDataSourceURI(self.camada.source())
                # abre uma outra uri na mesma base de dados
                self.uri = QgsDataSourceURI()
                self.uri.setConnection (self.uri_ex.host(), self.uri_ex.port(), self.uri_ex.database(), self.uri_ex.username(), self.uri_ex.password())
                itens_selecionados = self.dlg.treeWidget.selectedItems()
                
                if itens_selecionados.count(self.bac_mont):
                    self.geraMapaBacia(id_trecho, cobacia, dist_tr)
                if itens_selecionados.count(self.trechos_mont):
                    self.geraTrechosMontante(id_trecho, cobacia, dist_tr)
                if itens_selecionados.count(self.curso_princ_jus):
                    self.geraCursoPrincipalJusante(id_trecho, cobacia, dist_tr)
                if itens_selecionados.count(self.curso_tot_jus):
                    self.geraCursoTotalJusante(id_trecho, cobacia, dist_tr)
                if itens_selecionados.count(self.usina_mont):
                    self.geraUsinasMontante(cobacia, dist_tr)
                if itens_selecionados.count(self.usina_jus):
                    self.geraUsinasJusante(cobacia, dist_tr)
                if itens_selecionados.count(self.barr_mont):
                    self.geraBarragensMontante(cobacia, dist_tr)
                if itens_selecionados.count(self.barr_jus):
                    self.geraBarragensJusante(cobacia, dist_tr)
                if itens_selecionados.count(self.posto_flu_mont):
                    self.geraFluviometricasMontante(cobacia, dist_tr)
                if itens_selecionados.count(self.posto_flu_jus):
                    self.geraFluviometricasJusante(cobacia, dist_tr)
                if itens_selecionados.count(self.var_cens_mont):
                    self.geraTabelaVariaveisCensitarias(cobacia, id_trecho)
                if itens_selecionados.count(self.uso_solo_mont):
                    self.geraTabelaUsoSolo(cobacia, id_trecho)
                # camada corrente volta a ser hidrografia
                self.canvas.setCurrentLayer(self.camada)


        except ErroAcessoBaseDados:
            QMessageBox.warning(None, 'MontanteJusante', 'Nao conseguiu acesso a base de dados', 'OK')
            
        except ErroCamada:
            QMessageBox.warning(None, 'MontanteJusante', 'Favor selecionar camada Hidrografia', 'OK')
            
        except ExcecaoNadaSelecionado:
            pass
            
        except KeyError:
            QMessageBox.warning(None, 'MontanteJusante', 'Camada Hidrografia nao tem os atributos corretos', 'OK')
            
        except ErroMapaInvalido:
            QMessageBox.warning(None, 'MontanteJusante', 'Nao conseguiu criar o mapa', 'OK')
            
    def geraMapaBacia(self, cotrecho, cobacia, dist):
        # manda gerar a tabela montante_jusante.area_mont_x na base de dados (x é o código do trecho)
        # gera o string sql
        string_sql = 'SELECT gera_tabela_topologica(\'area_mont\', ' + str(cotrecho) + ', \'' + cobacia + '\', ' + '{0:.6f}'.format(dist) + ')'
        # estabelece uma conexão com a base de dados PostGIS com dados da conexao da camada hidrografia armazenados em self.uri_ex
        conn = psycopg2.connect(host=self.uri_ex.host(), port=self.uri_ex.port(), database=self.uri_ex.database(), user=self.uri_ex.username(), password=self.uri_ex.password())
        # executa o comando sql, que gera a tabela montante_jusante.area_montante_xxx, onde xxx é o id do trecho
        cur = conn.cursor()
        cur.execute(string_sql)
        # se assegura que as alterações da base de dados foram feitas e fecha o cursor e a conexão
        conn.commit()
        cur.close()
        conn.close()
        # seleciona a tabela montante_jusante.area_mont_xxx - coluna geomproj
        self.uri.setDataSource('montante_jusante', 'area_mont_' + str(cotrecho) , 'geomproj')
        #gera o titulo do mapa
        titulo = 'Area a montante de ' + str(cotrecho)
        #gera o mapa e acrescenta ao projeto
        mapa = QgsVectorLayer(self.uri.uri(), titulo, 'postgres')
        if not mapa.isValid():
            raise ErroMapaInvalido
        QgsMapLayerRegistry.instance().addMapLayer(mapa)
        # faz com que a cor das bordas das areas de contribuicao seja a do interior e refresca o mapa
        propriedades = mapa.rendererV2().symbol().symbolLayers()[0].properties()
        propriedades['outline_color'] = propriedades['color']
        mapa.rendererV2().setSymbol(QgsFillSymbolV2.createSimple(propriedades))
        
    def geraTrechosMontante(self, cotrecho, cobacia, dist):
        # manda gerar a tabela montante_jusante.trecho_mont_x na base de dados (x é o código do trecho)
        # gera o string sql
        string_sql = 'SELECT gera_tabela_topologica(\'trecho_mont\', ' + str(cotrecho) + ', \'' + cobacia + '\', ' + '{0:.6f}'.format(dist) + ')'
        # estabelece uma conexão com a base de dados PostGIS com dados da conexao da camada hidrografia armazenados em self.uri_ex
        conn = psycopg2.connect(host=self.uri_ex.host(), port=self.uri_ex.port(), database=self.uri_ex.database(), user=self.uri_ex.username(), password=self.uri_ex.password())
        # executa o comando sql, que gera a tabela montante_jusante.trecho_mont_xxx, onde xxx é o id do trecho
        cur = conn.cursor()
        cur.execute(string_sql)
        # se assegura que as alterações da base de dados foram feitas e fecha o cursor e a conexão
        conn.commit()
        cur.close()
        conn.close()
        # seleciona a tabela montante_jusante.trecho_mont_xxx - coluna geomproj_uni
        self.uri.setDataSource('montante_jusante', 'trecho_mont_' + str(cotrecho) , 'geomproj')
        #gera o titulo do mapa
        titulo = 'Trechos a montante de ' + str(cotrecho)
        #gera o mapa e acrescenta ao projeto
        mapa = QgsVectorLayer(self.uri.uri(), titulo, 'postgres')
        if not mapa.isValid():
            raise ErroMapaInvalido
        QgsMapLayerRegistry.instance().addMapLayer(mapa)
        
    def geraCursoPrincipalJusante(self, cotrecho, cobacia, dist):
        # manda gerar a tabela montante_jusante.curso_princ_jus_x na base de dados (x é o código do trecho)
        # gera o string sql
        string_sql = 'SELECT gera_tabela_topologica(\'curso_princ_jus\', ' + str(cotrecho) + ', \'' + cobacia + '\', ' + '{0:.6f}'.format(dist) + ')'
        # estabelece uma conexão com a base de dados PostGIS com dados da conexao da camada hidrografia armazenados em self.uri_ex
        conn = psycopg2.connect(host=self.uri_ex.host(), port=self.uri_ex.port(), database=self.uri_ex.database(), user=self.uri_ex.username(), password=self.uri_ex.password())
        # executa o comando sql, que gera a tabela montante_jusante.curso_princ_jus_xxx, onde xxx é o id do trecho
        cur = conn.cursor()
        cur.execute(string_sql)
        # se assegura que as alterações da base de dados foram feitas e fecha o cursor e a conexão
        conn.commit()
        cur.close()
        conn.close()
        # seleciona a tabela montante_jusante.curso_princ_jus_xxx - coluna geomproj_uni
        self.uri.setDataSource('montante_jusante', 'curso_princ_jus_' + str(cotrecho) , 'geomproj')
        #gera o titulo do mapa
        titulo = 'Curso princ jusante de ' + str(cotrecho)
        #gera o mapa e acrescenta ao projeto
        mapa = QgsVectorLayer(self.uri.uri(), titulo, 'postgres')
        if not mapa.isValid():
            raise ErroMapaInvalido
        QgsMapLayerRegistry.instance().addMapLayer(mapa)
        
    def geraCursoTotalJusante(self, cotrecho, cobacia, dist):
        # manda gerar a tabela montante_jusante.curso_total_jus_x na base de dados (x é o código do trecho)
        # gera o string sql
        string_sql = 'SELECT gera_tabela_topologica(\'curso_total_jus\', ' + str(cotrecho) + ', \'' + cobacia + '\', ' + '{0:.6f}'.format(dist) + ')'
        # estabelece uma conexão com a base de dados PostGIS com dados da conexao da camada hidrografia armazenados em self.uri_ex
        conn = psycopg2.connect(host=self.uri_ex.host(), port=self.uri_ex.port(), database=self.uri_ex.database(), user=self.uri_ex.username(), password=self.uri_ex.password())
        # executa o comando sql, que gera a tabela montante_jusante.area_montante_xxx, onde xxx é o id do trecho
        cur = conn.cursor()
        cur.execute(string_sql)
        # se assegura que as alterações da base de dados foram feitas e fecha o cursor e a conexão
        conn.commit()
        cur.close()
        conn.close()
        # seleciona a tabela montante_jusante.curso_total_jus_xxx - coluna geomproj_uni
        self.uri.setDataSource('montante_jusante', 'curso_total_jus_' + str(cotrecho) , 'geomproj')
        #gera o titulo do mapa
        titulo = 'Curso total jusante de ' + str(cotrecho)
        #gera o mapa e acrescenta ao projeto
        mapa = QgsVectorLayer(self.uri.uri(), titulo, 'postgres')
        if not mapa.isValid():
            raise ErroMapaInvalido
        QgsMapLayerRegistry.instance().addMapLayer(mapa)
        
    def geraUsinasJusante(self, cobacia, dist):
        # seleciona a tabela usinas - coluna geomproj
        self.uri.setDataSource('public', 'usinas', 'geomproj')
        # gera o string sql
        string_sql = '"cotrecho" IN (SELECT * FROM tr_jd(\'' + cobacia + '\', ' + '{0:f}'.format(dist) + '))'
        self.uri.setSql(string_sql)
        #gera o titulo do mapa
        titulo = 'Usinas a jusante de ' + cobacia
        #gera o mapa e acrescenta ao projeto
        mapa = QgsVectorLayer(self.uri.uri(), titulo, 'postgres')
        if not mapa.isValid():
            raise ErroMapaInvalido
        QgsMapLayerRegistry.instance().addMapLayer(mapa)
        
    def geraUsinasMontante(self, cobacia, dist):
        # seleciona a tabela usinas - coluna geomproj
        self.uri.setDataSource('public', 'usinas', 'geomproj')
        # gera o string sql
        string_sql = '"cotrecho" IN (SELECT * FROM tr_md(\'' + cobacia + '\', ' + '{0:f}'.format(dist) + '))'
        self.uri.setSql(string_sql)
        #gera o titulo do mapa
        titulo = 'Usinas a montante de ' + cobacia
        #gera o mapa e acrescenta ao projeto
        mapa = QgsVectorLayer(self.uri.uri(), titulo, 'postgres')
        if not mapa.isValid():
            raise ErroMapaInvalido
        QgsMapLayerRegistry.instance().addMapLayer(mapa)
        
    def geraBarragensJusante(self, cobacia, dist):
        # seleciona a tabela barragens - coluna geomproj
        self.uri.setDataSource('public', 'barragens', 'geomproj')
        # gera o string sql
        string_sql = '"cotrecho" IN (SELECT * FROM tr_jd(\'' + cobacia + '\', ' + '{0:f}'.format(dist) + '))'
        self.uri.setSql(string_sql)
        #gera o titulo do mapa
        titulo = 'Barragens a jusante de ' + cobacia
        #gera o mapa e acrescenta ao projeto
        mapa = QgsVectorLayer(self.uri.uri(), titulo, 'postgres')
        if not mapa.isValid():
            raise ErroMapaInvalido
        QgsMapLayerRegistry.instance().addMapLayer(mapa)
        
    def geraBarragensMontante(self, cobacia, dist):
        # seleciona a tabela barragens - coluna geomproj
        self.uri.setDataSource('public', 'barragens', 'geomproj')
        # gera o string sql
        string_sql = '"cotrecho" IN (SELECT * FROM tr_md(\'' + cobacia + '\', ' + '{0:f}'.format(dist) + '))'
        self.uri.setSql(string_sql)
        #gera o titulo do mapa
        titulo = 'Barragens a montante de ' + cobacia
        #gera o mapa e acrescenta ao projeto
        mapa = QgsVectorLayer(self.uri.uri(), titulo, 'postgres')
        if not mapa.isValid():
            raise ErroMapaInvalido
        QgsMapLayerRegistry.instance().addMapLayer(mapa)
        
    def geraFluviometricasJusante(self, cobacia, dist):
        # seleciona a tabela fluviometricas - coluna geomproj
        self.uri.setDataSource('public', 'fluviometricas', 'geomproj')
        # gera o string sql
        string_sql = '"cotrecho" IN (SELECT * FROM tr_jd(\'' + cobacia + '\', ' + '{0:f}'.format(dist) + '))'
        self.uri.setSql(string_sql)
        #gera o titulo do mapa
        titulo = 'Fluviometricas a jusante de ' + cobacia
        #gera o mapa e acrescenta ao projeto
        mapa = QgsVectorLayer(self.uri.uri(), titulo, 'postgres')
        if not mapa.isValid():
            raise ErroMapaInvalido
        QgsMapLayerRegistry.instance().addMapLayer(mapa)
        
    def geraFluviometricasMontante(self, cobacia, dist):
        # seleciona a tabela fluviometricas - coluna geomproj
        self.uri.setDataSource('public', 'fluviometricas', 'geomproj')
        # gera o string sql
        string_sql = '"cotrecho" IN (SELECT * FROM tr_md(\'' + cobacia + '\', ' + '{0:f}'.format(dist) + '))'
        self.uri.setSql(string_sql)
        #gera o titulo do mapa
        titulo = 'Fluviometricas a montante de ' + cobacia
        #gera o mapa e acrescenta ao projeto
        mapa = QgsVectorLayer(self.uri.uri(), titulo, 'postgres')
        if not mapa.isValid():
            raise ErroMapaInvalido
        QgsMapLayerRegistry.instance().addMapLayer(mapa)
        
    def geraTabelaVariaveisCensitarias(self, cobacia, id_trecho):
        # seleciona a tabela uso_acum_exp
        self.uri.setDataSource('public', 'var_censit_acum_exp', None)
        # gera o string sql
        string_sql = '"cotrecho" = ' + str(id_trecho)
        self.uri.setSql(string_sql)
        #gera o titulo do mapa
        titulo = 'Variaveis Censitarias a montante de ' + cobacia
        #gera o mapa e acrescenta ao projeto
        mapa = QgsVectorLayer(self.uri.uri(), titulo, 'postgres')
        if not mapa.isValid():
            raise ErroMapaInvalido
        QgsMapLayerRegistry.instance().addMapLayer(mapa)
        
    def geraTabelaUsoSolo(self, cobacia, id_trecho):
        # seleciona a tabela uso_acum_exp
        self.uri.setDataSource('public', 'uso_acum_exp', None)
        # gera o string sql
        string_sql = '"cotrecho" = ' + str(id_trecho)
        self.uri.setSql(string_sql)
        #gera o titulo do mapa
        titulo = 'Uso do solo a montante de ' + cobacia
        #gera o mapa e acrescenta ao projeto
        mapa = QgsVectorLayer(self.uri.uri(), titulo, 'postgres')
        if not mapa.isValid():
            raise ErroMapaInvalido
        QgsMapLayerRegistry.instance().addMapLayer(mapa)

