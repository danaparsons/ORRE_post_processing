function TreeSelectionChanged(app, event)
selectedNode = app.Tree.SelectedNodes;
app.chosenfiles = selectedNode.Text;  
end
