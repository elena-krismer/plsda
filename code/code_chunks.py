import pickle


"""
list subsystems
"""
def list_subsystems():
    with open('obj/subsystem_dict.pkl', 'rb') as f:
        sub_dict =  pickle.load(f)
    return list(sub_dict.keys())

# get reactions from subsystem
def subsystem_reactions(subsystem):
    with open('obj/subsystem_dict.pkl', 'rb') as f:
        dict =  pickle.load(f)
    sub_list = dict.get(subsystem)
    return sub_list

# reaction description
def get_reaction_description(humanone_reaction):
    with open('obj/reaction_description_dict.pkl', 'rb') as f:
        dict = pickle.load(f)
    description = dict.get(humanone_reaction)
    return description

def get_keggID(humanone_reactions):
    with open('obj/humanone_kegg_reaction_dict.pkl', 'rb') as f:
        dict = pickle.load(f)
    keggID_list = []
    for reactions in humanone_reactions:
        keggID = dict.get(reactions)
        keggID_list.append(keggID)
    return keggID_list

def html_table(reaction_list):
    with open('obj/humanone_kegg_reaction_dict.pkl', 'rb') as f:
        kegg_dict = pickle.load(f)
    string_table = "<table><tr><th> HumanOne Reaction <span class='tab'></span></th><th> keggID <span class='tab'></span> </th><th> Reaction description </th></tr><tr>"
    for reaction in reaction_list:
        description = str(get_reaction_description(reaction))
        if len(description) == 0:
            description = " "
        keggID = str(kegg_dict.get(reaction))
        if len(keggID) == 0:
            keggID = " "
        new_row = "</tr><tr><td> " + reaction + " </td><td><span class='tab'></span>" + keggID + " </td><td><span class='tab'></span> " + description + " </td>"
        string_table += new_row
    string_table += "</tr></table>"
    return str(string_table)


#print(get_reaction_description("MAR04693"))
