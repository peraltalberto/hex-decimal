HexDecimalView = require './hex-decimal-view'
{CompositeDisposable} = require 'atom'

module.exports = HexDecimal =
  hexDecimalView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @hexDecimalView = new HexDecimalView(state.hexDecimalViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @hexDecimalView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'hex-decimal:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'hex-decimal:toDecimal': => @toDecimal()
  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @hexDecimalView.destroy()

  serialize: ->
    hexDecimalViewState: @hexDecimalView.serialize()

  toggle: ->
    console.log 'HexDecimal was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  toDecimal: ->
    if editor = atom.workspace.getActiveTextEditor()
      @modalPanel.show()
      tabla = document.createElement('table')
      selection = editor.getSelectedText()
      hexData = selection.toString();
      result ='';
      arrHex = hexData.split(" ");
      tr1 = document.createElement('tr');
      for v in arrHex
        if (v.length < 2)
          v = '0'+v;
        td = document.createElement('th');
        td.textContent = v;
        tr1.appendChild(td)

      tabla.appendChild(tr1);
      tr2 = document.createElement('tr');
      for v in arrHex
        if (v.length < 2)
          v = '0'+v;

        td2 = document.createElement('td');
        td2.textContent =  parseInt(v, 16);
        tr2.appendChild(td2)

      tabla.appendChild(tr2);
      tabla.classList.add('table')
      tabla.classList.add('hexDecimal')
    @modalPanel.item.appendChild(tabla);
