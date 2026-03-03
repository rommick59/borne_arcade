import pygame
from constantes import RED, SCREEN_WIDTH, SCREEN_HEIGHT, PLAYER_SPEED

"""Module contenant la logique du joueur et de ses roues dans le jeu"""

class Player(pygame.sprite.Sprite):
    """Classe représentant le joueur contrôlé par le joueur
    
    Attributes:
        canon: Image du canon du joueur
        rect: Rectangle de collision du joueur
        image: Image actuelle du joueur
        speed_x: Vitesse horizontale du joueur
        score: Score du joueur
        wheelL: Roue gauche du joueur
        wheelR: Roue droite du joueur
    """
    
    def __init__(self):
        """Initialise le joueur avec son canon, position et roues"""
        super().__init__()
        self.canon = pygame.transform.scale(pygame.image.load("assets/canon.png"),(33,66))
        self.rect = self.canon.get_rect()
        self.image = self.canon
        self.rect.centerx = SCREEN_WIDTH // 2
        self.rect.bottom = SCREEN_HEIGHT - 10
        
        self.wheelL = Wheel(-20)
        self.wheelR = Wheel(20)
        
        self.speed_x = 0
        
        self.score = 0

    def update(self):
        """Met à jour la position du joueur et de ses roues"""
        self.speed_x = 0
        keys = pygame.key.get_pressed()
        if keys[pygame.K_LEFT]:
            self.speed_x = -PLAYER_SPEED
        if keys[pygame.K_RIGHT]:
            self.speed_x = PLAYER_SPEED
        
        w, h = self.image.get_size()
        
        self.rect.x += self.speed_x
        self.wheelL.translate(self.speed_x)
        self.wheelR.translate(self.speed_x)
        self.wheelL.rotate(self.speed_x*-1.4)
        self.wheelR.rotate(self.speed_x*-1.4)
        
        if self.rect.right > SCREEN_WIDTH:
            self.rect.right = SCREEN_WIDTH
        if self.rect.left < 0:
            self.rect.left = 0
    
    def kill(self):
        """Supprime le joueur et ses roues"""
        self.wheelL.kill()
        self.wheelR.kill()
        super().kill()
    
    def getWheels(self):
        """Retourne les roues du joueur"""
        return (self.wheelL,self.wheelR)
            
class Wheel(pygame.sprite.Sprite):
    """Classe représentant une roue du joueur
    
    Attributes:
        original_image: Image originale de la roue
        image: Image actuelle de la roue
        rect: Rectangle de collision de la roue
        xoffset: Décalage horizontal de la roue
        angleRotated: Angle de rotation actuel
    """
    
    def __init__(self,xoffset):
        """Initialise une roue avec son décalage et position"""
        super().__init__()
        self.original_image = pygame.transform.scale(pygame.image.load("assets/wheel.png"),(25,25))
        self.image = self.original_image
        self.rect = self.image.get_rect()
        self.xoffset = xoffset
        self.rect.centerx = SCREEN_WIDTH // 2 + xoffset
        self.rect.bottom = SCREEN_HEIGHT - 5
        self.angleRotated = 0
        
    def translate(self,x):
        """Déplace la roue horizontalement"""
        self.rect.x += x
        if self.rect.right > SCREEN_WIDTH + self.xoffset:
            self.rect.right = SCREEN_WIDTH + self.xoffset
        if self.rect.left < 0 + self.xoffset:
            self.rect.left = 0 + self.xoffset
    
    def rotate(self,angle):
        """Tourne la roue autour de son centre"""
        self.angleRotated += angle
        rotated_image = pygame.transform.rotate(self.original_image,self.angleRotated)
        rotated_rect = rotated_image.get_rect(center=self.rect.center)
        
        self.image = rotated_image
        self.rect = rotated_rect
