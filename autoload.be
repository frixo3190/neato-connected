# br load("autoexec.be")
import string # Nécessaire pour string.find sur certaines versions

print("")
print("")

# --- 1. NETTOYAGE PREVENTIF (Trés important) ---
# On supprime les anciennes tâches pour ne pas avoir de doublons
try 
    tasmota.remove_cron("vacuum_check") 
    print("BRY: Ancien Cron supprimé.")
except ..
    # On ignore l'erreur si le cron n'existait pas
end

try 
    tasmota.remove_rule("MtrReceived#5#Power") 
    print("BRY: Ancienne règle Matter supprimée.")
except ..
    # On ignore l'erreur si la regle n'existait pas
end

# --- CONFIGURATION ---
var BASE_URL = "http://192.168.70.87"
var URL_CLEAN = BASE_URL + "/button/house_clean/press"
var URL_STOP = BASE_URL + "/button/stop_cleaning/press"
var URL_LOCATE = BASE_URL + "/button/locate_robot/press"
var URL_STATUS = BASE_URL + "/text_sensor/ui_state"

print("\nBRY: Chargement du script REST...")

# --- 1. LA FONCTION DE VÉRIFICATION (Asynchrone avec timer) ---
def check_vacuum()
    try
        print("BRY: Tentative connexion HTTPS...")
        print("BRY: Memoire libre (Heap): " + str(tasmota.get_free_heap()) + " bytes")
        
        # Utilisation de set_timer pour exécution asynchrone
        tasmota.set_timer(0, def()
            var wc = webclient()
			print("BRY: " + URL_STATUS)
            wc.begin(URL_STATUS)
            wc.set_useragent("Tasmota")
            
            var ret = wc.GET()
            
            if ret == 200
                var body = wc.get_string()
                var is_cleaning = string.find(string.tolower(str(body)), "cleaning") >= 0
                
                print("BRY: Réponse HTTP reçue (Code: 200)")
                print("BRY: Contenu -> " + (is_cleaning ? "CLEANING" : "IDLE"))
                
                var relay_index = 0
                var current_state = tasmota.get_power()[relay_index]
                
                if is_cleaning != current_state
                    tasmota.set_power(relay_index, is_cleaning)
                    print("BRY: Sync Matter OK.")
                end
            else
                print("BRY: Erreur HTTP: " + str(ret))
            end
        end)
        
    except .. as e
        print("BRY: ### ERREUR CRITIQUE ###")
        print("BRY: Type d'erreur : " + str(e))
    end
end

# --- 2. L'ACTION BOUTON (Matter) ---
def handle_matter(value, trigger)
    if value == 1
        print("BRY: Matter ON -> Envoi REST...")
        
        try
            # Envoi asynchrone avec timer
            tasmota.set_timer(0, def() 
                var wc = webclient()
                wc.begin(URL_CLEAN)
                wc.set_useragent("Tasmota")
                var ret = wc.GET()
                
                if ret == 200
                    print("BRY: Commande envoyée avec succès")
                else
                    print("BRY: Erreur envoi (Code: " + str(ret) + ")")
                end
            end)
        except .. as e
            print("BRY: Erreur envoi commande: " + str(e))
        end
		
	else
	
		try
            # Envoi asynchrone avec timer
            tasmota.set_timer(0, def() 
                var wc = webclient()
                wc.begin(URL_STOP)
                wc.set_useragent("Tasmota")
                var ret = wc.GET()
                
                if ret == 200
                    print("BRY: Commande envoyée avec succès")
                else
                    print("BRY: Erreur envoi (Code: " + str(ret) + ")")
                end
            end)
        except .. as e
            print("BRY: Erreur envoi commande: " + str(e))
        end
	
	
    end
end

# --- INITIALISATION ---
tasmota.add_rule("MtrReceived#5#Power", handle_matter)
tasmota.add_cron("*/10 * * * * *", check_vacuum, "vacuum_check")

print("BRY: Script démarré.")